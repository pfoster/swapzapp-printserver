# Resources

## Jobs
###        **GET**    /jobs/?         
> ####index print jobs

####            Supported Formats       
> ##### JSON

####         Example
                {
                    "job" : {
                        "job_id"    : "1234567",
                        "completed" : "False",
                        "template"  : "string of printer code",
                        "printer"   : "Zebra_LP2844"
                    }
                }

#### Params
                
| Param Name    | Description   | Type  |
| ------------- |:-------------:| -----:|
| completed     | true if print job has been completed      | Boolean |
| template      | string of raw printer code                | String |
| printer       | name of printer job is being sent to      | String |

###        GET    /jobs/:id/?     
> #### find print job by id and print it

####            Supported Formats       
> ##### JSON
                
###        POST   /jobs/?         
> #### create new print job and print it

## Printers
###        GET    /printers/?     
> #### index printers

####            Supported Formats       
> ##### JSON

###         Example
                [
                    "Zebra_LP2844",
                    "printer2",
                    "printer3"
                ]


