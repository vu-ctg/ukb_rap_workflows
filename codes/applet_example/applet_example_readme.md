## Documentation on how to write an applet

```
dx-app-wizard
```

brings up a list of options to build the app. Just follow the promt to name the app and to specify inputs/outputs. 

**Notes**: if you need to install packages, make sure that internet access is granted: 
```
Access to the Internet (other than accessing the DNAnexus API).
Will this app need access to the Internet? [y/N]: y
```

Let's say that I named it `extract_block_ranges`. Then after running the above command, a folder called `extract_block_ranges` is created. Then it maybe necessary to edit the `dxapp.json` to:
- update the aws region. I changed mine to `aws:eu-west-2`
- if you need to install packages, edit the parameter `runSpec` like so: 
```
"runSpec": {
    "timeoutPolicy": {
      "*": {
        "hours": 1
      }
    },
    "interpreter": "python3",
    "file": "src/extract_block_ranges.py",
    "distribution": "Ubuntu",
    "release": "20.04",
    "version": "0",
    "execDepends": [{"name": "python3-pandas"}]
  }
```
    - According to https://documentation.dnanexus.com/faqs/developing-apps-and-applets, packages that are available as an APT package in ubuntu could be installed like this, so make sure that the package name exists in Ubuntu

Then build the app

```
# change to the app directory.
cd extract_block_ranges
dx build -a .
``` 

Then the app is ready to be run with 

```
dx run extract_block_ranges -iblock_pos=/path/ -iout_ranges=/path/ -iblock_id=/block/
```