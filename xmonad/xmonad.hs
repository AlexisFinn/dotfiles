import           Colors
import           Data.Ratio
--import           Graphics.X11
import           XMonad
import           XMonad.Actions.SpawnOn
import           XMonad.Config.Azerty
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.ManageHelpers
import           XMonad.Layout.Column
import           XMonad.Layout.Grid
import           XMonad.Layout.LayoutBuilder
import           XMonad.Layout.MultiToggle
import           XMonad.Layout.MultiToggle.Instances
import           XMonad.Layout.Reflect
import           XMonad.Layout.Spacing
import           XMonad.Layout.Spiral
import           XMonad.Layout.Tabbed
import           XMonad.StackSet                     as W
import           XMonad.Util.EZConfig
import           XMonad.Util.Run
import           XMonad.Util.WindowProperties

myConfig = azertyConfig
  { modMask = mod4Mask
  , terminal = "alacritty"
  , borderWidth = 4
  , normalBorderColor = color9
  , focusedBorderColor = color8
  , XMonad.workspaces = myWorkspaces
  , layoutHook = avoidStruts $ myLayouts
  , manageHook = myHooks
  , startupHook = myStartHooks
  } `additionalKeysP` myKeys

myStartHooks = spawn "$HOME/.xmonad/scripts/autostart.sh"

myHooks = composeAll
  [propertyToQuery (Role "GtkFileChooserDialog") --> doRectFloat(RationalRect (1 % 4) (1 % 4) (1 % 2) (1 % 2)) -- for navigator file browser dialog
  ]

xmobarTemplate = "'%StdinReader%}{<fc="
                  ++ color3
                  ++ ">%cpu%</fc><fc="
                  ++ color4
                  ++ ">%memory%</fc><fc="
                  ++ color5
                  ++ ">%disku%</fc><fc="
                  ++ color6
                  ++ ">%wlp2s0%</fc><fc="
                  ++ color7
                  ++ ">%date%</fc>'"

xmobarTemplateTwo = "'<fc="
                  ++ color7
                  ++ ">%track% (%album%), by %artist%</fc>'"

myKeys = [ ("M-x", spawnHere "rofi -combi-modi drun,run -show combi -modi combi -show-icons")
         , ("M-<Return>", spawnHere "alacritty")
         , ("M-<Space>", windows W.swapMaster)
         , ("M-S-r", spawn "killall xmobar; xmonad --recompile; xmonad --restart")
         , ("M-S-s", sendMessage NextLayout)
         , ("M-f", sendMessage $ Toggle FULL)
         , ("M-z", withFocused $ windows . W.sink)
         , ("<XF86AudioPlay>", spawn "playerctl play-pause")
         , ("<XF86AudioNext>", spawn "playerctl next")
         , ("<XF86AudioPrev>", spawn "playerctl previous")
         ]
         ++
          [ (mask ++ "M-" ++ [key], screenWorkspace scr >>= flip whenJust (windows . action))
            | (key, scr)  <- zip "te" [0..] -- change to match your screen order
              , (action, mask) <- [ (W.view, "") , (W.shift, "S-")]
          ]

myWorkspaces = [ "1\61524\59285"
               , "2\61524\59285"
               , "3\61524\59190"
               , "4\61524\61888"
               , "5\61524\61736"
               ]

-- myBarOne = "xmobar -x 0 --bgcolor=" ++ background ++ " --template=" ++ xmobarTemplate
myBarOne = "/home/alexis/.xmonad/scripts/xmobarOne.php"
--myBarTwo = "xmobar -x 1 --bgcolor=" ++ background ++ " --template=" ++ xmobarTemplateTwo ++ " /home/alexis/.config/xmobar/xmobarrc2"
myBarTwo = "/home/alexis/.xmonad/scripts/xmobarTwo.php"

myPP = xmobarPP { ppCurrent = xmobarColor background color1 . wrap " " " "
                , ppVisible = xmobarColor background color2 . wrap " " " "
                , ppHidden = xmobarColor color2 background . wrap " " " "
                , ppHiddenNoWindows = xmobarColor color2 background . wrap " " " "
                , ppOrder = \(ws:l:t) -> [ws]
                , ppWsSep = ""}

-- reminder: Border top bottom right left
myLayouts = spacingRaw True (Border 0 0 10 10 ) True (Border 5 5 10 10) True $
  mkToggle (NOBORDERS ?? FULL ?? EOT) $
    layoutTall |||
    mirroredTall |||
    simpleTabbed |||
    customLayout
        where
          layoutTall = Tall 1 (3/100) (2/3)
          mirroredTall = Mirror layoutTall
          mainHeight = (8/12)
          secWidth = (2/12)
          terWidth = (8/12)
          finalOffset = secWidth + terWidth * (1 - secWidth)
          customLayout = reflectVert ( cLayout1 $ cLayout2 $ cLayout3 $ cLayoutFinal )
          cLayout1 = (layoutN 1 (relBox 0 0 1 mainHeight) (Just $ relBox 0 0 1 1) $ Tall 1 0.01 1)
          cLayout2 = (layoutN 1 (relBox 0 mainHeight secWidth 1) (Just $ relBox 0 mainHeight 1 1) $ Tall 1 0.01 1)
          cLayout3 = (layoutN 1 (relBox secWidth mainHeight terWidth 1) (Just $ relBox secWidth mainHeight 1 1) $ Tall 1 0.01 1)
          cLayoutFinal = (layoutAll (relBox finalOffset mainHeight 1 1) $ Grid)
-- reminder: relBox x y width height




toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

main = do
  xmproc <- spawnPipe myBarOne
  musicBar <- spawnPipe myBarTwo
  xmonad $ docks myConfig
    { logHook = dynamicLogWithPP myPP { ppOutput = hPutStrLn xmproc }
    }




