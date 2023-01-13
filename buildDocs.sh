#!/usr/bin/env bash

#### Set environment variable for project root ####
project_root=$PWD

#### Create dist/ directory, if none exists ####
if [ ! -r ./dist ]; then
    echo "Creating dist/ directory..."
    mkdir dist/
fi

#### Generate example manuscript ####
# for linkml podman command usage, see https://hub.docker.com/r/linkml/linkml
clitool="linkml-validate"
cmdargs="-s manuscript-schema/manuscript-schema.yaml manuscript-example.yaml"
cmd="$clitool $cmdargs"
workdir=$project_root
podmancmd="podman run --rm -v $workdir:/work -w /work docker.io/linkml/linkml:1.3.14 $cmd"
condition="$clitool --help | grep 'Validates instance data'"

if ! eval $condition; then
    echo "Validating linkml model of example manuscript via podman..."
    cd $project_root
    eval $(echo $podmancmd)
else
    echo "Validating linkml model of example manuscript..."
    cd $workdir
    eval $cmd
    cd $project_root
fi

clitool="jinja2"
cmdargs="-o dist/manuscript-example.tex --format yaml manuscript-templates/aiaa-manuscript.tex.jinja2 manuscript-example.yaml"
workdir=$project_root
cmd="$clitool $cmdargs"
podmancmd="podman run --rm -v $workdir:/work -w /work docker.io/roquie/docker-jinja2-cli $cmdargs"
condition="$clitool --version | grep 'v0.8.2'"

if ! eval $condition; then
    echo "Generating LaTeX document from example manuscript linkml model and jinja2 template via podman..."
    cd $project_root
    eval $(echo $podmancmd)
else
    echo "Generating LaTeX document from example manuscript linkml model and jinja2 template..."
    cd $workdir
    eval $cmd
    cd $project_root
fi

echo "Copying LaTeX/BibTeX files and assets (required for generating PDF document) to dist/..."
cp -t dist/ *.bib manuscript-templates/*.bst manuscript-templates/*.cls assets/*

# workflow for generating LaTeX with BibTeX. See https://tex.stackexchange.com/questions/43325/citations-not-showing-up-in-text-and-bibliography
cmd="pdflatex manuscript-example.tex && bibtex manuscript-example.aux"
workdir=$project_root/dist
podmancmd="podman run --rm -v $workdir:/srv -w /srv docker.io/nanozoo/pdflatex:3.14159265--f2f4a3f $cmd"

if [ ! $(pdflatex -version | grep '3.14159265')] && [ ! $(bibtex -version | grep '0.99d') ]; then
    echo "Pre-Processing LaTeX document with BibTeX of example manuscript via podman..."
    cd $project_root
    eval $(echo $podmancmd)
else
    echo "Pre-Processing LaTeX document with BibTeX of example manuscript..."
    cd $workdir
    eval $cmd
    cd $project_root
fi

cmd="pdflatex manuscript-example.tex && pdflatex manuscript-example.tex"
workdir=$project_root/dist
podmancmd="podman run --rm -v $workdir:/srv -w /srv docker.io/nanozoo/pdflatex:3.14159265--f2f4a3f $cmd"

if [ ! $(pdflatex -version | grep '3.14159265')] && [ ! $(bibtex -version | grep '0.99d') ]; then
    echo "Generating PDF document from LaTeX/BibTeX document of example manuscript via podman..."
    cd $project_root
    eval $(echo $podmancmd)
else
    echo "Generating PDF document from LaTeX/BibTeX document of example manuscript..."
    cd $workdir
    eval $cmd
    cd $project_root
fi

