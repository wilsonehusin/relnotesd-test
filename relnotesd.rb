require "json"
require "octokit"

def compiled_markdown
  relnotes = Dir.glob("./datastore/*.json").map do |filename|
    JSON.parse(File.read(filename)).reject { |data| data["do_not_publish"] }
  end.reduce({}, :merge)

  content = relnotes.map { |note| note["markdown"] }.join "\n\n- "
  content = "- " + content

  <<~MD
    ### [BOT] Rendered Release Notes
    
    based on #{ENV["GITHUB_SHA"]}

    #{content}

    <details>
    <summary>Raw Markdown</summary>
    <br>
    
    <code>
      #{content}
    </code>
    </details>

  MD
end

raise "GitHub token is empty string!" if ENV["GITHUB_TOKEN"]&.empty?

client = Octokit::Client.new(access_token: ENV.fetch("GITHUB_TOKEN"))

client.add_comment(
  ENV["GITHUB_REPOSITORY"],
  ENV["GITHUB_ISSUE_NUMBER"].to_i,
  compiled_markdown,
)
