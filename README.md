This repository contains [Symfony Flex](https://symfony.com/packages/Symfony%20Flex) recipes developed by Torq. A recipe is a collection of files and file modifications that are applied to a project when a corresponding Composer package is added.

## Usage

To use these recipes in your project, follow these steps:

1. Add `symfony/flex` as a dependency of your project and ensure that the `allow-plugins` permissions is granted:
   ```
   composer require symfony/flex --no-install
   composer config --no-plugins allow-plugins.symfony/flex true
   ```
1. Add this repository as a recipes endpoint in your project's `composer.json`:

```
{
    ...
    "extra": {
        "symfony": {
            "endpoint": [
                "https://api.github.com/repos/TorqIT/recipes/contents/index.json?ref=flex/main",
                "flex://defaults"
            ]
        }
    }
}
```

1. Commit the changes that the above steps make to your `composer.json`, `composer.lock` and `symfony.lock` files. The `symfony.lock` file locks specific versions of Symfony recipes.
1. After making the above changes, whenever you add a new package to your project (i.e. `composer require`) that has a corresponding recipe in this repository, the recipe will get applied and the recipe version will be saved in your project's `symfony.lock` file.
   1. If your project already has a dependency for which you want to install a recipe, simply run `composer recipe:install <package owner>/<package name>`.
   1. Similarly, if you want to update a recipe without updating its corresponding package, run `composer recipes:update <package owner>/<package name>`.

## Contributing

Symfony's official instructions for custom recipes repositories are [here](https://symfony.com/doc/current/setup/flex_private_recipes.html), and while helpful, they assume a lot of manual steps that this repository automates. Symfony's [official recipes repository](https://github.com/symfony/recipes) also contains a good README on creating recipes that you can follow, but here are some simplified steps:

1. Determine the details of the Composer package you want to develop your recipe for (package owner, package name, and the minimum version(s) that you want to support)
1. Clone this repository to your local development environment (`git clone git@github.com:TorqIT/recipes.git`)
1. Create a series of nested folders at the root of the repository: `<package owner>/<package name>/<package version>` (e.g. `pimcore/data-hub/2.0`). Note that the package version should be the minimum version that your recipe supports - projects that use the package can then use the `^<minimum version number>` syntax in their `composer.json` in order to get your recipe. If you want to support multiple versions of a package, at present you need to create a sub-directory for each version.
1. In the `<package version>` directory, add a file called `manifest.json`. Add to this file any "configurator" declarations, which define the behavior of your recipe on installation. The list of available configurators and how to use them is detailed [here](https://github.com/symfony/recipes#configurators). The two most useful configurators in our experience are the `add-lines` configurator, which can be used to add content to files, and the `copy-from-recipe` configurator, which can be used to copy boilerplate configuration files for a package to your project.
1. Add a reference to your recipe and the versions it supports to the `"recipes"` object in `index.json`.
1. Add your changes to a new branch and open a Pull Request against `main`.
1. Once your branch is merged to `main`, a GitHub Action will create the necessary files that will allow projects to pull down your recipe (these are automatically pushed to the `flex/main` branch).
