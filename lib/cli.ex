defmodule Issues.CLI do
  @moduledoc """
  Handle the command line parsing and the dispatch to
  the various functions that end up generating a
  table of the last _n_ issues in a github project
  """

  alias Issues.GithubIssues
  alias Issues.TableFormatter

  @default_count 4

  def main(argv) do
    argv
    |> parse_args()
    |> process()
  end

  @doc """
  `argv` can be -h or --help, which returns :help

  the number of entries to format.

  Otherwise it is a github username, project name, and (optionally)
  Return a tuple of `{ user, project, count }`, or `:help` if help was given.
  """
  def parse_args(argv) do
    OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
    |> elem(1)
    |> args_to_internal_representation()
  end

  def process(:help) do
    IO.puts("""
      usage: issues <user> <project> [count | #{@default_count}]
    """)

    System.halt(0)
  end

  def process({user, project, count}) do
    GithubIssues.fetch(user, project)
    |> handle_response()
    |> sort_by_desc()
    |> last(count)
    |> TableFormatter.print_table_for_columns(["number", "created_at", "title"])
  end

  def last(list, count) do
    list
    |> Enum.take(count)
    |> Enum.reverse()
  end

  def sort_by_desc(issue) do
    issue
    |> Enum.sort(fn issue_one, issue_two -> issue_one["created_at"] >= issue_two["created_at"] end)
  end

  # private fns
  defp args_to_internal_representation([user, project, count]) do
    {user, project, String.to_integer(count)}
  end

  defp args_to_internal_representation([user, project]) do
    {user, project, @default_count}
  end

  defp args_to_internal_representation(_), do: :help

  defp handle_response({:ok, body}), do: body

  defp handle_response({:error, error}) do
    IO.puts("Error fetching from Github: #{error["message"]}")
    System.halt(2)
  end
end
