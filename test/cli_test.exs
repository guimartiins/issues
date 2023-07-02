defmodule IssuesCLITest do
  use ExUnit.Case
  doctest Issues

  import Issues.CLI, only: [parse_args: 1]

  describe "parse_args/1" do
    test ":help returned by option parsing with -h and --help options" do
      assert parse_args(["-h", "anything"]) == :help
      assert parse_args(["--help", "anything"]) == :help
    end

    test "three values returned if three given" do
      assert parse_args(["user", "project", 99]) == values()
    end

    test "count is defaulted if two values given" do
      values = values() |> Tuple.delete_at(2) |> Tuple.append(4)
      assert parse_args(["user", "project"]) == values
    end
  end

  defp values(), do: {"user", "project", 99}
end
