- Documentation on how to write an applet

```
dx-app-wizard
```

brings up a list of options to build the app. Let's say that I named it `extract_block_ranges`. Then after running the above command, a folder called `extract_block_ranges` is created. Then it maybe necessary to edit the `dxapp.json` to update the aws region. Then

```
dx build -a .
``` 

then the app is ready to be run with 

```
dx run extract_block_ranges -iblock_pos=/path/ -iout_ranges=/path/ -iblock_id=/block/
```