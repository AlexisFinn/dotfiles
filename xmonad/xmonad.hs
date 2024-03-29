import Colors
import Data.Map as M
import Data.Ratio

import XMonad
import XMonad.Actions.SpawnOn
import XMonad.Config.Azerty
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.Column
import XMonad.Layout.Grid
import XMonad.Layout.LayoutBuilder
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.Reflect
import XMonad.Layout.Spacing
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.StackSet as W
import XMonad.Util.EZConfig
import XMonad.Util.Run
import XMonad.Util.WindowProperties

myConfig =
  azertyConfig
    { modMask = mod4Mask
    , terminal = "alacritty"
    , borderWidth = 4
    , normalBorderColor = background
    , focusedBorderColor = color6
    , XMonad.workspaces = myWorkspaces
    , layoutHook = myLayouts
    , manageHook = myHooks
    , startupHook = myStartHooks
    , XMonad.keys = \c -> baseKeys c `M.union` XMonad.keys defaultConfig c
    } `additionalKeysP`
  myKeys

modm = mod4Mask

myStartHooks = spawn "$HOME/.xmonad/scripts/autostart.sh"

myHooks =
  composeAll
    [ propertyToQuery (Role "GtkFileChooserDialog") -->
      doRectFloat (RationalRect (1 % 4) (1 % 4) (1 % 2) (1 % 2)) -- for navigator file browser dialog
    ]

xmobarTemplate =
  "'%StdinReader%}{<fc=" ++
  color3 ++
  ">%cpu%</fc><fc=" ++
  color4 ++
  ">%memory%</fc><fc=" ++
  color5 ++
  ">%disku%</fc><fc=" ++
  color6 ++ ">%wlp2s0%</fc><fc=" ++ color7 ++ ">%date%</fc>'"

xmobarTemplateTwo = "'<fc=" ++ color7 ++ ">%track% (%album%), by %artist%</fc>'"

-- I need to do this to get my keyboard to respond properly as it's a french azerty
-- customised through QMK (I use an ergodox).
-- If you encounter issues with moving windows or switching between workspaces
-- just comment all this and try going from there.
myAzertyKeys = [0x26, 0xe9, 0x22, 0x27, 0x28, 0x2d, 0xe8, 0x5f, 0xe7, 0xe0]

baseKeys conf@(XConfig {XMonad.modMask = modm}) =
  M.fromList $
  [ ((m .|. modm, k), windows $ f i)
  | (i, k) <- zip (XMonad.workspaces myConfig) (Prelude.take 5 myAzertyKeys)
  , (f, m) <- [(W.shift, 0), (W.greedyView, shiftMask)]
  ]

myKeys =
  [ ( "M-x"
    , spawnHere "rofi -combi-modi drun,run -show combi -modi combi -show-icons")
  , ("M-<Return>", spawnHere "alacritty")
  , ("M-<Space>", windows W.swapMaster)
  , ("M-S-r", spawn "killall xmobar; xmonad --recompile; xmonad --restart")
  , ("M-S-s", sendMessage NextLayout)
  , ("M-f", sendMessage $ Toggle FULL)
  , ("M-z", withFocused $ windows . W.sink)
  , ("M-<F12>", spawn "lock")
  , ("<XF86AudioPlay>", spawn "playerctl play-pause")
  , ("<XF86AudioNext>", spawn "playerctl next")
  , ("<XF86AudioPrev>", spawn "playerctl previous")
  , ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +2%")
  , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ -2%")
  ] ++
  [ ( mask ++ "M-" ++ [key]
    , screenWorkspace scr >>= flip whenJust (windows . action))
  | (key, scr) <- zip "te" [0 ..] -- change to match your screen order
  , (action, mask) <- [(W.view, ""), (W.shift, "S-")]
  ]

myWorkspaces = ["1", "2", "3", "4", "5"]

-- configure my xmobar panel through php script
-- mainly because I know how to program in php so I can easily
-- achieve the desired result
myBarOne = "/home/alexis/.xmonad/scripts/xmobarOne.php"

myBarTwo = "/home/alexis/.xmonad/scripts/xmobarTwo.php"

myPP =
  xmobarPP
    { ppCurrent = xmobarColor background color1 . wrap " " " "
    , ppVisible = xmobarColor background color2 . wrap " " " "
    , ppHidden = xmobarColor color2 background . wrap " " " "
    , ppHiddenNoWindows = xmobarColor color2 background . wrap " " " "
    , ppOrder = \(ws:l:t) -> [ws]
    , ppWsSep = ""
    }

-- reminder: Border top bottom right left
myLayouts =
  avoidStruts $ -- leave some space for the panel
  spacingRaw True (Border 5 5 10 10) True (Border 5 5 10 10) True $ -- space the windows for effect
  mkToggle (NOBORDERS ?? FULL ?? EOT) $
  layoutTall ||| mirroredTall ||| mirroredThreeColumns
    --customLayout
  where
    layoutTall = Tall 1 (3 / 100) (3 / 4)
    mirroredTall = Mirror layoutTall
    threeColumns = ThreeColMid 1 (3 / 100) (2 / 3)
    mirroredThreeColumns = reflectVert $ Mirror threeColumns

toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

main = do
  xmproc <- spawnPipe myBarOne
  musicBar <- spawnPipe myBarTwo
  xmonad $
    docks
      myConfig {logHook = dynamicLogWithPP myPP {ppOutput = hPutStrLn xmproc}}
