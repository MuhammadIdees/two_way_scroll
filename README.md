# two_way_scroll

A new Flutter widget. It is a custom sliver list that scroll both ways i.e. with it's items being vertical or horizontal. This can be useful in created options, menus or it can even can be a custom drawer.
 
   I didn't find any way to make a list item rotate properly in sliver list
   even though the item themselves rotated but the list only scrolled when
   the items were horizontal and couldn't adjust elements when they were
   vertical.
 
   What is done to make this word is I have used the rotated box (which get's
   the job done of scrolling horizontally as well as vertically) and then rotated
   the rotated box using Transform.rotate for a smooth rotation along with a
   Transform.translate to keep everything in place.
 
   To orchestrate the animation each item some calculations were took in consideration
   keeping the item's height and width in mind and some factors were taken in
   account which can be observed in the code below to make the code flexible
   enough for item of any height and width.
 
 
