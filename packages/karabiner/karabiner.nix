{ config, pkgs, lib, ... }:

{
  # Karabiner-Elements configuration for macOS keyboard customization
  # Note: Karabiner-Elements is installed via Homebrew (see darwin-work.nix homebrew configuration)
  # This module only manages the configuration files
  
  config = lib.mkIf pkgs.stdenv.isDarwin {
    # Create Karabiner configuration directory and files
    home.file.".config/karabiner/karabiner.json" = {
      text = builtins.toJSON {
        global = {
          ask_for_confirmation_before_quitting = true;
          check_for_updates_on_startup = true;
          show_in_menu_bar = true;
          show_profile_name_in_menu_bar = false;
          unsafe_ui = false;
        };
        
        profiles = [
          {
            name = "Default profile";
            parameters = {
              delay_milliseconds_before_open_device = 1000;
            };
            selected = true;
            
            # Simple modifications to remap function key to control
            simple_modifications = [
              {
                from = {
                  key_code = "fn";
                };
                to = [
                  {
                    key_code = "left_control";
                  }
                ];
              }
            ];
            
            # Function key behavior - use F1, F2, etc. as standard function keys
            fn_function_keys = [
              {
                from = {
                  key_code = "f1";
                };
                to = [
                  {
                    key_code = "display_brightness_decrement";
                  }
                ];
              }
              {
                from = {
                  key_code = "f2";
                };
                to = [
                  {
                    key_code = "display_brightness_increment";
                  }
                ];
              }
              {
                from = {
                  key_code = "f3";
                };
                to = [
                  {
                    key_code = "mission_control";
                  }
                ];
              }
              {
                from = {
                  key_code = "f4";
                };
                to = [
                  {
                    key_code = "launchpad";
                  }
                ];
              }
              {
                from = {
                  key_code = "f5";
                };
                to = [
                  {
                    key_code = "illumination_decrement";
                  }
                ];
              }
              {
                from = {
                  key_code = "f6";
                };
                to = [
                  {
                    key_code = "illumination_increment";
                  }
                ];
              }
              {
                from = {
                  key_code = "f7";
                };
                to = [
                  {
                    key_code = "rewind";
                  }
                ];
              }
              {
                from = {
                  key_code = "f8";
                };
                to = [
                  {
                    key_code = "play_or_pause";
                  }
                ];
              }
              {
                from = {
                  key_code = "f9";
                };
                to = [
                  {
                    key_code = "fast_forward";
                  }
                ];
              }
              {
                from = {
                  key_code = "f10";
                };
                to = [
                  {
                    key_code = "mute";
                  }
                ];
              }
              {
                from = {
                  key_code = "f11";
                };
                to = [
                  {
                    key_code = "volume_decrement";
                  }
                ];
              }
              {
                from = {
                  key_code = "f12";
                };
                to = [
                  {
                    key_code = "volume_increment";
                  }
                ];
              }
            ];
            
            # Complex modifications (none for now, but structure is ready)
            complex_modifications = {
              parameters = {
                "basic.simultaneous_threshold_milliseconds" = 50;
                "basic.to_delayed_action_delay_milliseconds" = 500;
                "basic.to_if_alone_timeout_milliseconds" = 1000;
                "basic.to_if_held_down_threshold_milliseconds" = 500;
                "mouse_motion_to_scroll.speed" = 100;
              };
              rules = [];
            };
            
            # Device-specific settings
            devices = [];
            
            # Virtual HID keyboard settings
            virtual_hid_keyboard = {
              country_code = 0;
              indicate_sticky_modifier_keys_state = true;
              mouse_key_xy_scale = 100;
              keyboard_type_v2 = "ansi";
            };
          }
        ];
      };
      
      # Restart Karabiner service when configuration changes
      onChange = ''
        if command -v launchctl >/dev/null 2>&1; then
          echo "Restarting Karabiner-Elements service..."
          launchctl kickstart -k gui/$(id -u)/org.pqrs.karabiner.karabiner_console_user_server 2>/dev/null || true
        fi
      '';
    };
    
    # Post-installation guidance activation
    home.activation.karabinerSetup = lib.hm.dag.entryAfter ["writeBoundary"] ''
      if [[ "$(uname)" == "Darwin" ]]; then
        echo ""
        echo "============================================"
        echo "Karabiner-Elements Configuration Applied"
        echo "============================================"
        echo ""
        echo "Important post-installation steps:"
        echo "1. Launch Karabiner-Elements from Applications or Spotlight"
        echo "2. Grant Accessibility permissions when prompted"
        echo "3. Grant Input Monitoring permissions when prompted"
        echo "4. The function key (fn) should now work as Control"
        echo ""
        echo "If the remapping doesn't work immediately:"
        echo "• Restart Karabiner-Elements from the menu bar"
        echo "• Check that the 'Default profile' is selected"
        echo "• Verify permissions in System Preferences > Security & Privacy"
        echo ""
        echo "Configuration file location:"
        echo "  ~/.config/karabiner/karabiner.json"
        echo "============================================"
        echo ""
      fi
    '';
  };
}