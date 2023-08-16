I needed to process a group of checkboxes, and to determine which had been checked, this frame does this and returns a handy TArray<string> of the checkbox names that have been selected.

Features (set by properties):
1) It can be set for either single or multiple selection
2) Background and frame border colour can be adjusted to suit 
3) Coloured helpers for design 
4) Content changed so allignment can be used by user 
5) Customisable padding for content

Usage: just add the frame to your form resize as you need, and layout your checkboxes to it in the order you wish

Returns: TArray<string> or TArray<TCheckbox> of the checkbox names that have been selected, by calling the checked_names property [#version

DominicM 
2023/08/16 

Change log
2023/08/16 First release v2
2023/08/16 ver 3, features 3,4 and 5 added following feedback
2023/08/16 ver 4, added property to return unchecked items
2023/08/17 ver 5, hide caption if blank text supplied
