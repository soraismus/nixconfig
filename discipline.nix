{ config, lib, pkgs, ... }:

let
  cfg = config.services.discipline;

  # Blocked domains
  # ---------------
  #
  # Each entry here is a top-level domain to sink.
  # Subdomains are # handled by adding explicit entries
  #
  # (Wildcard syntax doesn't exist in /etc/hosts,
  # so we enumerate the common ones).
  #
  # To add a domain:
  # append it to the appropriate list below,
  # and then `sudo nixos-rebuild switch`.
  #
  # The rebuild friction is the point.

  socialMedia = [
    "nitter.com" "www.nitter.com"
    "reddit.com" "www.reddit.com" "old.reddit.com"
  ];

  video = [
    "m.youtube.com"
    "www.youtube.com"
    "youtu.be"
    "youtube.com"
    "youtube-nocookie.com"
    "ytimg.com"  # Thumbnail CDN; blocking this breaks embeddings.
  ];

  news = [
    "hckernews.com"
    "marginalrevolution.com" "www.marginalrevolution.com"
    "nationalreview.com" "www.nationalreview.com"
    "news.ycombinator.com"
    "newyorker.com" "www.newyorker.com"
    "nytimes.com" "www.nytimes.com"
    "theatlantic.com" "www.theatlantic.com"
  ];

  # Allowlist note
  # --------------
  #
  # The hosts file is a blunt instrument:
  # it doesn't support path-based rules.
  # To allow *specific* YouTube channels while blocking the rest,
  # the intended workflow is:
  #
  #  0. Block youtube.com here (enabled by default in `video` above).
  #  1. Install FreeTube (`environment.systemPackages = [ pkgs.freetube ]`)
  #     and manage your subscriptions there.
  #  2. FreeTube fetches via Invidious or local extraction,
  #     so it bypasses the hosts-file sink entirely.
  #
  # If you need browser-based access to a specific video,
  # temporarily open it through an Invidious instance (not blocked above)
  # or disable the module and rebuild.
  # The rebuild cost is the friction.

  allBlocked =
       (lib.optionals cfg.blockSocialMedia socialMedia)
    ++ (lib.optionals cfg.blockVideo video)
    ++ (lib.optionals cfg.blockNews news);

  # Build the hosts-file stanza:
  # one line per domain, sunk to 127.0.0.1.
  hostsLines = lib.concatMapStringsSep "\n"
    (domain: "127.0.0.1  ${domain}")
    allBlocked;

in
{
  # Interface
  # ---------

  options.services.discipline = {
    enable = lib.mkEnableOption "hosts-file-based site blocking";

    blockSocialMedia = lib.mkOption {
      type    = lib.types.bool;
      default = true;
      description = "Sink social-media domains to localhost.";
    };

    blockVideo = lib.mkOption {
      type    = lib.types.bool;
      default = true;
      description = "Sink video-platform domains (YouTube, etc.) to localhost.";
    };

    blockNews = lib.mkOption {
      type    = lib.types.bool;
      default = false;
      description = "Sink news domains to localhost.  Populate the `news` list first.";
    };

    extraBlocked = lib.mkOption {
      type    = lib.types.listOf lib.types.str;
      default = [];
      example = [ "example.com" "www.example.com" ];
      description = "Additional domains to sink, beyond the built-in lists.";
    };
  };

  # Implementation
  # --------------

  config = lib.mkIf cfg.enable {
    networking.extraHosts =
      let
        extraLines = lib.concatMapStringsSep "\n"
          (domain: "127.0.0.1  ${domain}")
          cfg.extraBlocked;
      in
      lib.concatStringsSep "\n" (lib.filter (s: s != "") [
        "# ── discipline module: blocked domains ──"
        hostsLines
        extraLines
        "# ── end discipline module ──"
      ]);
  };
}
