# manuscript-example
Example manuscript using a model-based approach

A PDF document of the example manuscript generated from this repo's continuous deployment (CD) pipeline is available at https://odu-cga-cubesat.github.io/manuscript-example/manuscript-example.pdf

## Installing requirements

You will need [git](https://git-scm.com/downloads) to clone the project contents and [podman](https://podman.io/getting-started/installation) to run the podman images that contain the dependencies needed for generating a PDF document of the example manuscript locally.

- [git](https://git-scm.com/downloads).
- [podman](https://podman.io/getting-started/installation).

Alternatively, you can run the following instructions inside the [sealion-workspace-image](https://github.com/ODU-CGA-CubeSat/sealion-workspace-image).

Note: It is recommended you run the following instructions on a Linux/Unix-like operating system. If you are on a Windows machine, consider installing [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10).

## Cloning the repo

Clone the [manuscript-example](https://github.com/ODU-CGA-CubeSat/manuscript-example) repo. This will create a local copy of the repo on your local machine. Don't forget to use `--recurse-submodules` flag, or else you won't pull down some of the code you need to generate a PDF document of the example manuscript.

```bash
git clone --recurse-submodules https://github.com/ODU-CGA-CubeSat/manuscript-example.git
```

Note: If you accidentally cloned without using `--recurse-submodules`, you can run `git submodule update --init --recursive` to pull down submodules needed to generate a working manuscript.

Once you've cloned the repo, you'll need to change directory into the repo you just cloned, using the `cd` command:

```bash
cd manuscript-example
```

## Generating a PDF document

Once you've installed requirements and cloned the repo, run the `buildDocs.sh` script in the project root directory. This will validate the `manuscript-example.yaml` against the schema defined in the `manuscript-schema/` directory, then generate a PDF document of the example manuscript in the `dist/` directory using the Jinja2 templates and LaTeX/BibTeX typesetters/formatters defined in `manuscript-templates/`.

```bash
./buildDocs.sh
```

---
Code for this work is licensed under an [MIT License](./LICENSE)

Content for this work is licensed under a [Creative Commons Attribution 4.0 International License](http://creativecommons.org/licenses/by/4.0/)
