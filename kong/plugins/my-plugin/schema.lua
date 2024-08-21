 local PLUGIN_NAME = "my-plugin"

 local schema = {
   name = PLUGIN_NAME,
   fields = {
     { config = {
         type = "record",
         fields = {
         },
       },
     },
   },
 }
 
 return schema