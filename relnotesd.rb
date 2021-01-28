require "file"
require "json"
require "octokit"

client = Octokit::Client.new(access_token: ENV.fetch("GITHUB_TOKEN"))

client.add_comment(
  ENV["GITHUB_REPOSITORY"],
  ENV["GITHUB_ISSUE_NUMBER"],
  compiled_markdown,
)

def compiled_markdown
  relnotes = File.glob("./maps/*.json").map do |filename|
    JSON.parse(File.read(filename)).reject { |data| data["do_not_publish"] }
  end

  content = relnotes.map { |note| note["markdown"] }.join "\n\n- "
  content = "- " + content

  <<~MD
    # Rendered Release Notes Result
    
    based on #{ENV["GITHUB_SHA"]}

    #{content}

    <details open>
    <summary>Raw Markdown</summary>
    <br>
    
    <code>
      #{content}
    </code>
    </details>

  MD
end
