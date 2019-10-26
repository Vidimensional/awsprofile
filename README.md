# awsprofile

Manage different aws profiles easily on Bash.

## Installation

```bash
go get github.com/vidimensional/awsprofile
```

## Usage

```bash
awsprofile $profile_name
```

Where `$profile_name` is the name of the profile on `~/.aws/credentials`.

### Autocompletion (bash only)

Source `awsprofile-completion.bash` 

```bash
$ awsprofile account<TAB>
account_production     account_preproduction
```
