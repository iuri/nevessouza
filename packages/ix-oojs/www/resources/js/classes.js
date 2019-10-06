
var object_type 
public abstract class object_type {    
    constructor(text){
	this._text = text;
    }
     
    public integer supertype;

	=> 'acs_object',
    object_type => 'ticket',
    pretty_name => 'Ticket',
    pretty_plural => 'Tickets',
    table_name => 'tickets',
    id_column => 'ticket_id',
    name_method => 'acs_object.default_name'
    
    
    
    public integer object_id = 0;
    public string name() {
	return "Object Name:" + this.objectName; 
    }
    

}

public abstract class content_keyword : object {

}


public abstract class content_item : object {
    public string 'my_item';
    public integer parent_id;
    public string title 'My Item',
       text      => 'Once upon a time Goldilocks crossed the street.  
Here comes a car...uh oh!  The End',
       is_live   => 't'
}
public abstract class content_revision : object {

}



public abstract class content_folder : content_item {

}


public abstract class content_template : content_item {

}


public abstract class content_symlink : content_item {

}

public abstract class content_extlink : content_item {

}


public abstract class custom_content_types : content_item {

}

