# How to contribute

Third-party patches are essential for keeping mongoid-autoinc great.
We want to keep it as easy as possible to contribute changes that get things working in your environment.
There are a few guidelines that we need contributors to follow so that we can have a chance of keeping on top of things.

Follow the styleguide when changing code:
[80beans Styleguide](https://gist.github.com/suweller/b896eb9e66fc6ab3640d)

## Making Changes

* Create an issue so we can discuss the patch and prevent duplication of effort.
* Create a topic branch from where you want to base your work.
  * This is usually the `master` branch.
  * Only target release branches if you are certain your fix must be on that
    branch.
  * To quickly create a topic branch based on master; `git branch
    my_contribution master` then checkout the new branch with `git
    checkout my_contribution`.  Please avoid working directly on the
    `master` branch.
* Make commits of logical units.
* Check for unnecessary whitespace with `git diff --check` before committing.
* Make sure your commit messages are in the proper format.

```
    Clarify CONTRIBUTING with an example

    Without this patch applied the example commit message in the CONTRIBUTING
    document is not a concrete example.  This is a problem because the
    contributor is left to imagine what the commit message should look like
    based on a description rather than an example.  This patch fixes the
    problem by making the example concrete and imperative.

    The first line is a real life imperative statement with a ticket number
    from our issue tracker.  The body describes the behavior without the patch,
    why this is a problem, and how the patch fixes the problem when applied.

    Closes issue #11
```

* Reference the issue created earlier like in the above example commit.
* Make sure you have added the necessary tests for your changes.
* Run _all_ the tests to assure nothing else was accidentally broken.
* Create a pull-request.
