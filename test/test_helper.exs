ExUnit.configure(formatters: [JUnitFormatter, ExUnit.CLIFormatter])

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(BankStone.Repo, :manual)

File.mkdir_p(Path.dirname(JUnitFormatter.get_report_file_path()))
