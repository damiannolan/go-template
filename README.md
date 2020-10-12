# Go HTTP Service Template

## Getting Started

> Go is an open source programming language that makes it easy to build simple, reliable, and efficient software.

A comprehensive guide to getting up and running with a Go (Golang) development environment.

### Prerequisites

- [Git](https://git-scm.com/downloads)
- [Make](https://www.gnu.org/software/make/)
- Basic programming skills
- An IDE of your choice - [Visual Studio Code](https://code.visualstudio.com/download) (Recommended)

### Download and Install

Navigate to https://golang.org/dl/ and choose a suitable binary release for your system. 
Download the installer and follow the onscreen instructions provided by the installation wizard.

### Preparing VS Code
Microsoft provides the most popular extension for Visual Studio Code for Go development. It can be downloaded through the Extensions tab on the left sidebar navigation menu or accessed through the keyboard shortcut `ctrl + shift + x`.

Open Exensions and search for Rich Go Language Support for Visual Studio Code.

![vscode-extension](https://i.gyazo.com/a6ae59cab194869fd83c251c6aa09eeb.png)

Note you may be prompted to restart your editor or to allow the extension to install a number of dependencies.

For example: The extension makes use of existing packages for some common tasks such as organised imports and code formatting on save actions through goimports and gofmt respectively.

### Verifying your Go Installation

Create a file `hello.go` and paste in the following:

```go
package main
 
import "fmt"
 
func main() {
    fmt.Printf("hello world")
}
```

Here we are importing package **"fmt"**. Package **"fmt"** implements formatted I/O with functions analogous to C's printf and scanf. See https://golang.org/pkg/fmt/.

Save the file in the current directory and open a terminal window. Run the following command:

```bash
go run hello.go
```

![hello-output](https://i.gyazo.com/ca72a80822fa01b525053d8bdfc2b0f2.png)

You're now ready to start coding in Go!

## Go Modules

### Overview 

This project has already been setup to use [Go Modules](https://blog.golang.org/using-go-modules) as it's dependency management tool.
Go Modules was added in Go 1.11 and is being actively improved ever since. It is built into the Go Toolchain and now the defacto standard for dependency management in Go.
Proir to Go 1.13, developers must enable Modules through the env var `GO111MODULE=on`. As of Go 1.13, Module mode is the default for all development.
For more on Go Modules, checkout the [official documentation](https://blog.golang.org/using-go-modules) 4 part blog series and for an insight into transitioning to Go Modules checkout [this article!](https://dev.to/maelvls/why-is-go111module-everywhere-and-everything-about-go-modules-24k)

### Configuration for non-public modules

In order to use private modules, e.g. from a company repository, set the env variable `GOPRIVATE` - https://golang.org/cmd/go/#hdr-Module_configuration_for_non_public_modules.

The go command defaults to downloading modules from the public Go module mirror at proxy.golang.org. It also defaults to validating downloaded modules, regardless of source, against the public Go checksum database at sum.golang.org. The `GOPRIVATE` environment variable controls which modules the go command considers to be private (not available publicly) and should therefore not use the proxy or checksum database. The enviornment variable is a comma-separated list of glob patterns (in the syntax of Go's path.Match) of module path prefixes.

Set the env variable in your shell or if using Windows configure through the Windows environment variables UI.

```bash
export GOPRIVATE=example.mycompany.com
```

### Quick Start

1. Initializing a new Go Module for a fresh project can achieved through the `go mod init` command.
For example:

```bash
go mod init github.com/damiannolan/go-template
```

2. Downloading a dependency can be done through the use of the `go get` command. 
For example: 

```bash
go get github.com/Shopify/sarama
```

Specificying a particular branch or semantic version tag.

```bash
go get github.com/Shopify/sarama@pr/feature-branch

go get github.com/Shopify/sarama@v1.27.1
```

3. Other useful commands are included below, more information can be acquired through `go help mod`.

Download modules to local cache. This is useful for scenarios such as Docker builds. See the project [Dockerfile](./Dockerfile) for an example where Go Modules files are copied into the working directory and `go mod download` is run in order to cache dependency in an image layer. Only if dependencies have changed they are re-downloaded. This improves build time when developing.

```bash
go mod download
```

Dependencies can be cleaned up, whereby the Go Modules tool adds missing and removes unused modules.

```bash
go mod tidy
```

Maintaining a local vendored copy of dependencies. This downloads and creates a `/vendor` directory at the root of the Module.

```bash
go mod vendor
```

Verify the expected content of modules.

```bash
go mod verify
```

## Makefile Usage

The project template provides a `Makefile` containing a set of directives for common tasks such as:
    - Docker Builds
    - Helm Deployments
    - Unit Testing
    - Versioning

`Makefiles` are very common in Go projects and are often setup to accomodate the needs of a particular project or application. Tasks are executed via the `make` command. The `Makefile` can be easily extended to allow developers the opportunity to add their own custom directives for automating tasks. More information can be found at [GNU Make - GNU.org](https://www.gnu.org/software/make/manual/make.html).

### Building Docker Images

Building and pushing an application image:

```bash
make docker-build

make docker-push
```

Building and pushing a development image:
Here the image tag is a reference to the user - acquired through `$(shell whoami)`

```bash
make docker-build-dev

make docker-push-dev
```

### Helm Deployments

Deploy to a Kubernetes cluster via Helm:

```bash
make helm-deploy

make helm-deploy-dev
```

### Unit Testing

Unit Testing in Go is performed through the Go Toolchain via the `go test` command. A directive has been included to run tests from all directories and output a `coverage.out` file which can be analysed by reporting tools such as Sonar.
 
Running application unit tests:

```bash
make test
```