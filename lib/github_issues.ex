defmodule Issues.GithubIssues do
  @user_agent [{"User-Agent", "Elixir academicgmag@gmail.com"}]

  def fetch(user, project) do
    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response()
  end

  def issues_url(user, project) do
    "#{github_url()}/repos/#{user}/#{project}/issues"
  end

  defp handle_response({_, %{status_code: status_code, body: body}}) do
    {status_code |> check_status(), body |> decode()}
  end

  defp check_status(200), do: :ok

  defp check_status(_), do: :error

  defp decode(body), do: Jason.decode(body)

  def github_url(), do: Application.get_env(:issues, :github_url)
end
