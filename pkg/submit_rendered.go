package relnotesd

import (
	"context"

	"github.com/google/go-github/v33/github"
	"golang.org/x/oauth2"
)

type GithubRepositoryRef struct {
	Organization string
	Repository   string
	Type         string // [issue,pull]
	Number       int
}

func (gh *GithubClient) SubmitComment(ref GithubRepositoryRef, data string) error {
	switch ref.Type {
	case "issue":

	}
	return nil
}

type GithubClient struct {
	Ctx    context.Context
	Client github.Client
}

func NewGithubClient(accessToken string) GithubClient {
	ctx := context.Background()
	ts := oauth2.StaticTokenSource(
		&oauth2.Token{AccessToken: accessToken},
	)
	tc := oauth2.NewClient(ctx, ts)

	return &GithubClient{Ctx: ctx, Client: github.NewClient(tc)}
}
