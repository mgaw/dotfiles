{
  lib,
  config,
  username,
  ...
}:

# Not automated:
# - Alfred
#   - Hotkey: Cmd-Space
#   - Appearance -> Option -> Hide menu bar icon
#   - Appearance -> Choose "Alfred Dark"
# - Logitech Options
#   - Middle mouse button => middle mouse button
#   - Tilting mouse wheel => backwards/forwards
#   - "up" button to Ctrl-H and "down" button to Ctrl-L for buffer navigation in vim.

{
  home = {
    inherit username;
    homeDirectory = "/Users/${username}";
  };

  home.activation = {
    # Lock Screen -> Require password after [...]: Immediately
    setScreenLock = lib.hm.dag.entryAfter [ "writeBoundary" ] /* sh */ ''
      if ! /usr/sbin/sysadminctl -screenLock status 2>&1 | grep -q immediate; then
        run echo "Setting screen lock to immediate (password required)..."
        run /usr/sbin/sysadminctl -screenLock immediate -password -
      fi
    '';

    # Lock Screen -> Turn display off on battery/power adapter when inactive: For 5 minutes
    setDisplaySleep = lib.hm.dag.entryAfter [ "writeBoundary" ] /* sh */ ''
      current=$(/usr/bin/pmset -g custom |
        /usr/bin/grep displaysleep |
        /usr/bin/awk '{ print $2 }' |
        /usr/bin/sort -u)
      if [ "$current" != "5" ]; then
        run echo "Setting display sleep to 5 minutes (sudo required)..."
        run /usr/bin/sudo /usr/bin/pmset -a displaysleep 5
      fi
    '';

    # Battery -> Options... -> Prevent automatic sleeping on power adapter when the display is off: Enable
    setPreventSleep = lib.hm.dag.entryAfter [ "writeBoundary" ] /* sh */ ''
      current=$(/usr/bin/pmset -g custom |
        /usr/bin/awk '/AC Power/ { in_ac = 1 } in_ac && $1 == "sleep" { print $2; exit }')
      if [ "$current" != "0" ]; then
        run echo "Setting prevent sleep on power adapter (sudo required)..."
        run /usr/bin/sudo /usr/bin/pmset -c sleep 0
      fi
    '';

    # Needed for some settings to apply without logging out and back in
    activateSettings = lib.hm.dag.entryAfter [ "setDarwinDefaults" ] /* sh */ ''
      run /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';
  };

  targets.darwin = {
    keybindings = {
      "^w" = "deleteWordBackward:";
      "^j" = "insertNewline:";
    };

    currentHostDefaults = {
      "com.apple.controlcenter" = {
        AirplayReceiverEnabled = false; # General -> AirDrop & Handoff -> Disable "AirPlay Receiver"
      };
      "com.apple.coreservices.useractivityd" = {
        # General -> AirDrop & Handoff -> Disable "Allow Handoff [...]"
        ActivityAdvertisingAllowed = false;
        ActivityReceivingAllowed = false;
      };
    };

    defaults = {
      NSGlobalDomain = {
        "com.apple.keyboard.fnState" = true; # Use F1, F2, etc. keys as standard function keys
        AppleFontSmoothing = 1; # Make fonts look better on 1x displays
        AppleKeyboardUIMode = 2; # Keyboard -> Enable "Keyboard Navigation"
        AppleShowAllExtensions = true;
      };
      "com.apple.HIToolbox" = {
        AppleFnUsageType = 0; # Keyboard -> Press "Globe" key to: "Do Nothing"
      };
      "com.apple.AppleMultitouchTrackpad" = {
        # Trackpad -> Enable "Tap to click"
        # For some reason this doesn't update the System Settings checkbox. It seems to work though.
        Clicking = true;
        # Accessibility -> Pointer Control -> Trackpad Options... -> Enable "Use trackpad for dragging" (with drag lock)
        # For some reason this doesn't update the System Settings checkbox. It seems to work though.
        # There is also `com.apple.AppleMultitouchTrackpad.DragLock`, which seems to correspond to the "With drag lock"
        # option in the settings. But it looks like it works with drag lock without setting that.
        Dragging = true;
      };
      "com.apple.dock" = {
        autohide = true;
        orientation = "left";
        persistent-apps = [ ];
        persistent-others =
          map
            (dir: {
              tile-data = {
                arrangement = 4; # Date Created
                file-data = {
                  _CFURLString = "file://${dir}";
                  _CFURLStringType = 15;
                };
              };
              tile-type = "directory-tile";
            })
            [
              "${config.home.homeDirectory}/Downloads/"
              "${config.home.homeDirectory}/Screenshots/"
              "${config.home.homeDirectory}/Documents/"
            ];
        show-recents = false;
        tilesize = 50;
        wvous-bl-corner = 2; # Bottom left screen corner → Mission Control
        wvous-br-corner = 4; # Bottom right screen corner → Desktop
        wvous-tl-corner = 10; # Top left screen corner → Put display to sleep
      };
      "com.apple.finder" = {
        _FXShowPosixPathInTitle = true; # Show full path in title
        FXEnableExtensionChangeWarning = false;
        FXPreferredViewStyle = "clmv"; # Prefer column view
        NewWindowTarget = "PfHm"; # New window points to home
      };
      "com.apple.menuextra.clock" = {
        # Show seconds in system clock
        DateFormat = "EEE d. MMM  HH:mm:ss";
        ShowSeconds = true;
      };
      "com.apple.screencapture" = {
        location = "~/Screenshots"; # Save screenshots in ~/Screenshots instead of ~/Desktop
      };
      "com.apple.symbolichotkeys" = {
        AppleSymbolicHotKeys = {
          "36".enabled = false; # Keyboard -> Keyboard Shortcuts -> Mission Control -> Disable "Show Desktop F11"
          # Keyboard -> Keyboard Shortcuts -> Spotlight -> Configure Option-Space for "Show Spotlight search"
          "64" = {
            enabled = true;
            value = {
              type = "standard";
              parameters = [
                32 # Space keyChar
                49 # Space keyCode
                524288 # Option modifier
              ];
            };
          };
        };
      };
      "com.apple.WindowManager" = {
        EnableTilingByEdgeDrag = false; # Drag windows to screen edges to tile
        EnableTopTilingByEdgeDrag = false; # Drag windows to menu bar to fill screen
      };
      # https://github.com/rxhanson/Rectangle/blob/main/TerminalCommands.md
      "com.knollsoft.Rectangle" = {
        alternateDefaultShortcuts = 0; # Use Spectacle-style shortcuts
        hideMenubarIcon = 1;
        launchOnLogin = 1;
        subsequentExecutionMode = 0; # Repeated commands: cycle sizes on half actions
        selectedCycleSizes = 18; # Cycle 1/2 and 3/4
        windowSnapping = 2; # Disable "Snap windows by dragging"
        SUEnableAutomaticChecks = 1;
        firstThreeFourths = {
          modifierFlags = 1310720; # Cmd+Ctrl
          keyCode = 123; # Left
        };
        lastThreeFourths = {
          modifierFlags = 1310720; # Cmd+Ctrl
          keyCode = 124; # Right
        };
      };
      "com.ranchero.NetNewsWire-Evergreen" = {
        SUEnableAutomaticChecks = true;
      };
    };
  };
}
