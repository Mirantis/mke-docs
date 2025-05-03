# MKE 4k Documentation

The `mke-docs` repository contains the MKE 4k documentation content and all
the assets that are required to build the [MKE 4k documentation website](https://mirantis.github.io/mke-docs/),
which uses Hugo with the [Hextra theme](https://imfing.github.io/hextra/).
Currently, the docs are published using GitHub actions on GitHub pages from the `main` branch.

To build and preview MKE 4k documentation:

1. Install [Hugo](https://gohugo.io/installation/) on your local system.

2. Start the Hugo server from within your local `mke-docs` repository:

    ```bash
    hugo server
    ```

3. View the local documentation build at http://localhost:1313/mke-docs/.
