export function exportCSVFile(headers, totalData, fileTitle){
    console.log('totalData-->',totalData);
    if(!totalData || !totalData.length){
        return null
    }
    const jsonObject = JSON.stringify(totalData,function (key, value) {
        console.log('this is value:'+this.value)
        return (value === null) ? "" : value;
    })
    const result = convertToCSV(jsonObject,headers)
    if(!result){
        return null
    }
    const blob = new Blob([result], {type: 'text/plain;charset=utf-8'})
    const exportedFileName = fileTitle? fileTitle+'.csv':'export.csv'
    if(navigator.msSaveBlob){
        navigator.msSaveBlob(blob, exportedFileName)
    }else if(navigator.userAgent.match(/iPhone|iPad|iPod/i)){
        const link = window.document.createElement('a')
        link.href='data:text/csv;charset=utf-8,' + encodeURI(result);
        link.target = "_blank"
        link.download=exportedFileName
        link.click()
    } else {
        const link = window.document.createElement('a')
        if(link.download !== undefined){
            //const url = URL.createObjectURL(blob);
            const url ='data:text/csv;charset=utf-8,' + encodeURI(result);
            link.setAttribute('href', url)
            link.setAttribute('download', exportedFileName)
            link.style.visibility='hidden'
            document.body.appendChild(link)
            link.click()
            document.body.removeChild(link)
        }
    }
  }

  function convertToCSV(objArray, headers){
    const columnDelimiter = ','
    const lineDelimiter = '\r\n'
    const actualHeaderKey = Object.keys(headers)
    const headersToShow = Object.values(headers)
    let str =''
    str+=headersToShow.join(columnDelimiter)
    str+=lineDelimiter
    const data = typeof objArray !== 'object' ? JSON.parse(objArray) : objArray
    data.forEach(obj=>{
        let line=''
        actualHeaderKey.forEach(key=>{
            if(line!=''){
                line+=columnDelimiter
            }
            let strItem
            if(obj[key]){
                 strItem = obj[key].replace('\n',' ')+''
            }
            
            line+=(strItem !== undefined && strItem !== 'undefined') ? strItem.replace(/,/g, ''):((strItem===undefined || strItem==='undefined')?'':strItem)
        })
        str+=line+lineDelimiter
    })
    return str
  }