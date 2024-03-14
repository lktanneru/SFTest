import LightningDatatable from 'lightning/datatable';
import customPickList from './customPickList.html';
import customTextArea from './customTextArea.html';


export default class CustomTypeGlobal extends LightningDatatable {
    
    static customTypes ={
        statusPicklist:{
            template: customPickList,
            standardCellLayout: true,
            typeAttributes:['label','value','options','placeholder','context','variant','name']
        },
        CommentsTextArea: {
            
            template: customTextArea,
            standardCellLayout: true,
            typeAttributes: ['placeholder', 'comments', 'value', 'context'],
        },
    };

}