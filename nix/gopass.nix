{ pkgs, ... }:

{
  home.packages = with pkgs; [
    gopass
    gopass-jsonapi
  ];

  # These files would usually be created by `gopass-jsonapi configure --browser {firefox,chrome}`
  home.file =
    let
      # https://github.com/gopasspw/gopass-jsonapi/blob/master/internal/jsonapi/manifest/wrapper.go
      wrapperScript = pkgs.writeShellScript "gopass_wrapper.sh" ''
        export GPG_TTY="$(${pkgs.coreutils}/bin/tty)"
        eval "$(${pkgs.gnupg}/bin/gpg-agent --daemon)"
        ${pkgs.gopass-jsonapi}/bin/gopass-jsonapi listen
        exit $?
      '';
    in
    {
      # https://github.com/gopasspw/gopass-jsonapi/blob/master/internal/jsonapi/manifest/manifest_path_darwin.go
      "Library/Application Support/Mozilla/NativeMessagingHosts/com.justwatch.gopass.json".text = (
        builtins.toJSON {
          # https://github.com/gopasspw/gopass-jsonapi/blob/master/internal/jsonapi/manifest/manifest.go
          name = "com.justwatch.gopass";
          description = "Gopass wrapper to search and return passwords";
          path = "${wrapperScript}";
          type = "stdio";
          allowed_extensions = [ "{eec37db0-22ad-4bf1-9068-5ae08df8c7e9}" ];
        }
      );
      "Library/Application Support/Google/Chrome/NativeMessagingHosts/com.justwatch.gopass.json".text = (
        builtins.toJSON {
          name = "com.justwatch.gopass";
          description = "Gopass wrapper to search and return passwords";
          path = "${wrapperScript}";
          type = "stdio";
          allowed_origins = [ "chrome-extension://kkhfnlkhiapbiehimabddjbimfaijdhk/" ];
        }
      );
    };
}
