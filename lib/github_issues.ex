defmodule Issues.GithubIssues do
  require Logger

  @user_agent [{"User-Agent", "Elixir academicgmag@gmail.com"}]

  def fetch(user, project) do
    Logger.info("Fetching #{user}'s project #{project}")

    user
    |> issues_url(project)
    |> HTTPoison.get(@user_agent)
    |> handle_response()
  end

  def issues_url(user, project) do
    "#{github_url()}/repos/#{user}/#{project}/issues"
  end

  defp handle_response({_, %{status_code: status_code, body: body}}) do
    Logger.info("Got response: status code=#{status_code}")

    {check_status(status_code), decode(body)}
  end

  defp check_status(200), do: :ok

  defp check_status(_), do: :error

  defp decode(body) do
    {:ok, body} = Jason.decode(body)
    body
  end

  def github_url(), do: Application.get_env(:issues, :github_url)
end
