# awsprofile

Manage different aws profiles easily on Bash.

## Installation

```bash
go get github.com/vidimensional/awsprofile@go_implementation
```

## Usage

```bash
awsprofile $profile_name
```

Where `$profile_name` is the name of the profile on `~/.aws/credentials`.

Also you can use autocompletion:

```bash
$ awsprofile account<TAB>
account_production     account_preproduction
```
