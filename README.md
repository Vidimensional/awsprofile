# awsprofile

Manage different aws profiles easily on the shell.

You can find a previous implementation in Bash in the branch [bash_implementation](https://github.com/Vidimensional/awsprofile/tree/bash_implementation).

## Prerequisites

* [`awscli` tool](https://aws.amazon.com/cli/).
* Some profiles configured with `awscli`.

## Installation

```bash
go get github.com/vidimensional/awsprofile
```

## Usage

### Change profile

```bash
awsprofile $profile_name
```

### List your configured profiles

```bash
$ awsprofile
production
preproduction
personal
```

### Autocompletion (bash only)

Source `awsprofile-completion.bash` 

```bash
$ awsprofile account<TAB>
account_production     account_preproduction
```
