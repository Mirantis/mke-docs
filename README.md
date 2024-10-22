# MKE 4 Documentation

The `mke-docs` repository contains the MKE 4 documentation content and all
the assets that are required to build the [MKE 4 documentation website](https://mirantis.github.io/mke-docs/),
which uses Hugo with the [Hextra theme](https://imfing.github.io/hextra/).
Currently, the docs are published using GitHub actions on GitHub pages from the `main` branch.

To build and preview MKE 4 documentation:

1. Install [Hugo](https://gohugo.io/installation/).

2. Start the Hugo server from within your local `mke-docs` repository:

    ```bash
    hugo server
    ```

3. View the local build of documentation at http://localhost:1313/mke-docs/.
