name: terraform-aws

on:
  push:
    branches:
      - test
  workflow_dispatch:

permissions:
  id-token: write
  contents: read

env:
  AWS_REGION: "us-east-1"
  GITHUB_TOKEN: "${{ secrets.GIT_TOKEN }}"

jobs:
  init-plan:
    runs-on: ubuntu-latest
    environment: ${{ github.event.inputs.stage }}
    steps:
      - name: Checkout
        uses: actions/checkout@v2
      - name: configure aws credentials
        uses: aws-actions/configure-aws-credentials@v2
        with:
          role-to-assume: arn:aws:iam::559954683639:role/github_oidc
          role-session-name: terraform
          aws-region: ${{ env.AWS_REGION }}

      - name: terraform fmt
        run: |
          terraform fmt --recursive
      - name: oidc
        run: |
          cd oidc
          terraform init
          terraform apply -auto-approve
