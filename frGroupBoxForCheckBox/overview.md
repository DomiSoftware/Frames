I needed to process a group of checkboxes, and to determine which had been checked, this frame does this and returns a TArray of string or TArray of TCheckbox for the checkbox names that have been selected.

Features (set by properties):
1) It can be set for either single or multiple selection
2) Background and frame border colour can be adjusted to suit 
3) Coloured helpers for design 
4) Content changed so allignment can be used by user 
5) Customisable padding for content
6) (v4) allows checklist usage, now can return unchecked items

Usage: just add the frame to your form resize as you need, and layout your checkboxes to it in the order you wish

Returns: TArray of string or TArray of TCheckbox for the checkbox names that have been selected or (v4+) not

DominicM 
2023/08/16 

Change log
2023/08/16 First release v2
2023/08/16 v3, features 3,4 and 5 added following feedback
           v4, added property to return unchecked items
2023/08/17 v5, hide caption if blank text supplied
