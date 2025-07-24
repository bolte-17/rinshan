# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Rinshan.Repo.insert!(%Rinshan.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Rinshan.Imports.SheetSource

[
  %SheetSource{
    sheet_id: "1Jj4wLG_fJ1VDXaOj_MVtyDCtlYCJmsBsOhh5X3gHsWM",
    year: 2024,
    tags: [:friendly],
    registry_range: "'Registry'!A2:F",
    games_range: "'Raw Scores'!A2:P"
  },
  %SheetSource{
    sheet_id: "1w-uHWXMEQBrsjcwURkU5W_lBeLb8tvD2ljcphV29nNI",
    year: 2024,
    tags: [:club],
    registry_range: "'Registry'!A2:F",
    games_range: "'Raw Scores'!A2:P"
  },
  %SheetSource{
    sheet_id: "1xCSF-82TBTO7AA0LHA40IfUadIvO4Fa7s1xSs5L6aJg",
    year: 2025,
    tags: [:preseason],
    registry_range: "'Registry'!A2:F",
    games_range: "'Raw Scores'!A2:P"
  },
  %SheetSource{
    sheet_id: "1eXyLBo6lHmn1QvMbkPHxHivdCZNWYYjAmn8MWElAkt0",
    year: 2025,
    tags: [:club],
    registry_range: "'Registry'!A2:F",
    games_range: "'Raw Scores'!A2:P"
  }
]
|> Enum.each(&Rinshan.Repo.insert!/1)

Rinshan.Accounts.register_user(%{"email" => "brian@bolte.dev", "password" => "password1234"})
