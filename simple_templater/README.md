# Simple Templater

This is a very simple formatter that takes a template and a json file
containing the variables. It uses Pythons format function to generate the output.

**Note that this is the opposite of advanced.**  
If you want a serious templating engine, make use of a so called search engine
to find one. If you did this already, and this was your best hit, I am
sorry to tell you that you have a problem.


# Usage

## Okaaaaay let's go

First, write a template file, e.g.

```
... some text {a_variable}, some more text
.....
.. {another_variable}
```

Now create a json file containing all the vars:

```json
{
    "a_variable": "about a secret project",
    "another_variable": 42
}
```

After that, run 

```
./simple_templater.py -t template_file.txt -j variables.json -o output_file.txt
```

The `output_file.txt` will contain the following:

```
... some text about a secret project, some more text
.....
.. 42
```

# Commandline arguments

Just a quick reminder: `./simple_templater.py -h` is your friend.
