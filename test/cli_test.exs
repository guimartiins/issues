defmodule IssuesCLITest do
  use ExUnit.Case
  doctest Issues

  import Issues.CLI

  describe "parse_args/1" do
    test ":help returned by option parsing with -h and --help options" do
      assert parse_args(["-h", "anything"]) == :help
      assert parse_args(["--help", "anything"]) == :help
    end

    test "three values returned if three given" do
      assert parse_args(["user", "project", "99"]) == values()
    end

    test "count is defaulted if two values given" do
      values = values() |> Tuple.delete_at(2) |> Tuple.append(4)
      assert parse_args(["user", "project"]) == values
    end
  end

  describe "sort_by_desc/1" do
    test "sort descending correctly" do
      result = sort_by_desc(fake_created_at_list(~w(a c b)s))
      issues = for issue <- result, do: Map.get(issue, "created_at")

      assert issues == ~w(c b a)s
    end
  end

  defp fake_created_at_list(list) do
    for item <- list,
        do: %{"created_at" => item, "other_data" => "xxxx"}
  end

  defp values(), do: {"user", "project", 99}
end
