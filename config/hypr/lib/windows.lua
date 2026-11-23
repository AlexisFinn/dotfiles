-- Window navigation, layout cycling and tab groups for the master layout.
-- Every function runs inside a key bind or event callback and only issues
-- dispatchers: no blocking call is made.

local M = {}

local SETTLE_DELAY_MS = 10

local default_orientations = {}
local orientations = {}
local tabbed = {}

-- `list` holds { id, name, orientation?, tabbed? } entries. The tables below
-- are keyed by id, which windows report as their workspace's addressable
-- name. The orientation of the
-- master layout is not exposed to Lua; it is inferred from window positions
-- when possible, and otherwise taken from the last value set here, starting
-- with the one configured for the workspace.
function M.setup(list)
  default_orientations = {}
  orientations = {}
  tabbed = {}
  for _, ws in ipairs(list) do
    default_orientations[ws.id] = ws.orientation or "left"
    orientations[ws.id] = default_orientations[ws.id]
    tabbed[ws.id] = ws.tabbed or false
  end
end

local function dispatch(dispatcher)
  hl.dispatch(dispatcher)
end

local function address_selector(w)
  return "address:" .. w.address
end

local function workspace_name(w)
  return w.workspace and w.workspace.addressable_name
end

-- A group of two or more windows is a tab bar; a lone window in a group is not.
local function in_tab_group(w)
  local g = w and w.group
  return g ~= nil and g.size > 1
end

local function tiled_windows(ws)
  local out = {}
  for _, w in ipairs(hl.get_windows()) do
    if w.mapped and not w.floating and workspace_name(w) == ws.addressable_name then
      out[#out + 1] = w
    end
  end
  return out
end

-- The group shared by every window of the list, or nil.
local function shared_group(wins)
  local g = wins[1] and wins[1].group
  if not g then
    return nil
  end
  for i = 2, #wins do
    if wins[i].group ~= g then
      return nil
    end
  end
  return g
end

-- "top" when every slave lies below the master, "left" when every slave lies
-- beside it, or nil when the workspace shows fewer than two layout targets.
-- When the geometry is ambiguous the slave nearest to the master decides.
local function inferred_orientation(wins)
  local master
  local slaves = {}
  for _, w in ipairs(wins) do
    local layout = w.layout
    if layout and layout.is_master ~= nil then
      if layout.is_master then
        master = master or w
      else
        slaves[#slaves + 1] = w
      end
    end
  end
  if not (master and #slaves > 0) then
    return nil
  end

  local extent = master.size or { x = 0, y = 0 }
  local below, beside = true, true
  local nearest, nearest_distance
  for _, slave in ipairs(slaves) do
    local dx = slave.at.x - master.at.x
    local dy = slave.at.y - master.at.y
    below = below and dy >= extent.y
    beside = beside and dx >= extent.x
    local distance = math.abs(dx) + math.abs(dy)
    if not nearest_distance or distance < nearest_distance then
      nearest, nearest_distance = slave, distance
    end
  end
  if below ~= beside then
    return below and "top" or "left"
  end
  return math.abs(nearest.at.y - master.at.y) > math.abs(nearest.at.x - master.at.x) and "top" or "left"
end

-- Next/previous window: tab inside a group, otherwise the layout order.
function M.focus_step(forward)
  local w = hl.get_active_window()
  if in_tab_group(w) then
    dispatch(forward and hl.dsp.group.next() or hl.dsp.group.prev())
  elseif w and w.floating then
    dispatch(hl.dsp.window.cycle_next({ next = forward }))
  else
    dispatch(hl.dsp.layout(forward and "cyclenext" or "cycleprev"))
  end
end

-- Move the window down/up the stack; inside a group, move its tab.
function M.shuffle(forward)
  local w = hl.get_active_window()
  if in_tab_group(w) then
    dispatch(hl.dsp.group.move_window({ forward = forward }))
  elseif w and not w.floating then
    dispatch(hl.dsp.layout(forward and "swapnext" or "swapprev"))
  end
end

local function set_orientation(ws, orientation)
  dispatch(hl.dsp.layout("orientation" .. orientation))
  orientations[ws.addressable_name] = orientation
end

local function group_all(wins, base)
  if not base then
    return
  end
  if not base.group then
    dispatch(hl.dsp.group.toggle({ window = address_selector(base) }))
  end
  local target = base.group
  if not target then
    return
  end
  for _, w in ipairs(wins) do
    if w.group ~= target then
      pcall(target.add, target, w)
    end
  end
  dispatch(hl.dsp.focus({ window = address_selector(base) }))
end

local function ungroup_all(wins, focus)
  for _, w in ipairs(wins) do
    if w.group then
      dispatch(hl.dsp.group.toggle({ window = address_selector(w) }))
    end
  end
  if focus then
    dispatch(hl.dsp.focus({ window = address_selector(focus) }))
  end
end

-- Cycle of the current workspace: master left -> master top -> one tab group
-- -> master left. A workspace without tiled window is left alone.
function M.next_layout()
  local active = hl.get_active_window()
  local ws = (active and active.workspace) or hl.get_active_workspace()
  if not ws then
    return
  end

  local wins = tiled_windows(ws)
  if #wins == 0 then
    return
  end

  local focus = wins[1]
  for _, w in ipairs(wins) do
    if active and w == active then
      focus = w
    end
  end

  local state
  if shared_group(wins) then
    state = "group"
  else
    state = inferred_orientation(wins) or orientations[ws.addressable_name] or "left"
  end

  if state == "group" then
    ungroup_all(wins, focus)
    set_orientation(ws, "left")
  elseif state == "left" then
    set_orientation(ws, "top")
  else
    group_all(wins, focus)
  end
end

-- Tabbed workspaces hold their tiled windows in one group; other workspaces
-- hold none. A window that opens or lands on a workspace is brought in line.
function M.settle(w)
  if not (w and w.mapped) or w.floating then
    return
  end
  local name = workspace_name(w)
  if not name then
    return
  end
  local own = w.group

  if not tabbed[name] then
    if own then
      pcall(own.remove, own, w)
    end
    return
  end

  if own and own.size > 1 then
    return
  end
  for _, other in ipairs(hl.get_windows()) do
    if other ~= w and other.mapped and not other.floating and other.group
        and workspace_name(other) == name and other.group ~= own then
      local target = other.group
      pcall(target.add, target, w)
      return
    end
  end
  if not own then
    dispatch(hl.dsp.group.toggle({ window = address_selector(w) }))
  end
end

-- A move may happen in the middle of the compositor's own group handling, so
-- the window is settled from a timer.
function M.settle_later(w)
  hl.timer(function() M.settle(w) end, { timeout = SETTLE_DELAY_MS, type = "oneshot" })
end

-- Send only the active window to a workspace, without following it: a window
-- in a group leaves the group first, otherwise the whole group would move.
function M.send_to_workspace(id)
  local w = hl.get_active_window()
  if not w then
    return
  end
  local selector = address_selector(w)
  if w.group then
    dispatch(hl.dsp.window.move({ window = selector, out_of_group = true }))
  end
  dispatch(hl.dsp.window.move({ window = selector, workspace = id, follow = false }))
end

return M
