{ lib, ... }:
{
  name = "gotosocial";
  meta.maintainers = with lib.maintainers; [ blakesmith ];

  nodes.machine =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.jq ];
      services.gotosocial = {
        enable = true;
        setupPostgresqlDB = true;
        settings = {
          host = "localhost:8081";
          port = 8081;
          instance-stats-mode = "serve";
        };
      };
    };

  testScript = ''
    machine.wait_for_unit("gotosocial.service")
    machine.wait_for_unit("postgresql.target")
    machine.wait_for_open_port(8081)
    # Database migrations are running, wait until gotosocial no longer serves 503
    machine.wait_until_succeeds("curl -sS -f http://localhost:8081/readyz", timeout=300)

    # check user registration via cli
    machine.succeed("gotosocial-admin account create --username nickname --email email@example.com --password kurtz575VPeBgjVm")
    machine.wait_until_succeeds("curl -sS -f http://localhost:8081/nodeinfo/2.0 | jq '.usage.users.total' | grep -q '^1$'")
  '';
}
