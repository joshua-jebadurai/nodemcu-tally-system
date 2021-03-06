const cheerio = require("cheerio");
const http = require("http");
const options = {
  hostname: "localhost",
  port: 8088,
  path: "/tally",
  method: "GET"
};
//http://localhost:8088/tally/?key=66529fcb-985f-4164-8b44-6a02441a62e9
//http://localhost:8088/tallyupdate/?key=66529fcb-985f-4164-8b44-6a02441a62e9
const mappings = {
  'ab821d88-a5e2-4b4c-8f26-7fee5d038db8': '192.168.1.108',
  '06ec2885-3fd0-4a3b-8bc5-fdb05104f64f': '192.168.1.109'
}

getKeys (options);

function getKeys(options) {
  const req = http.request(options, res => {
  console.log(`statusCode: ${res.statusCode}`);

    res.on("data", d => {
      //process.stdout.write(d);
      const $ = cheerio.load(d);
      $(".tallyLink").each(function(index, element) {
        console.log(element.attribs["href"]);
        console.log(element.children[0].data);
        options.path = element.attribs["href"].replace ('tally', 'tallyupdate');
        console.log (options.path);
        getColor (options);
      });
    });
  });

  req.on("error", error => {
    console.error(error);
  });

  req.end();
}

function getColor(options) {
  const req = http.request(options, res => {
    res.on("data", d => {  
      var res = options.path.split('=');
      console.log (res[1]);
      process.stdout.write(d);
    });
  });

  req.on("error", error => {
    console.error(error);
  });

  req.end();
}



/*console.log (url)
let updateOptions = {
  hostname: "localhost",
  port: 8088,
  path: url,
  //path: element.attribs["href"].replace("tally", "tallyupdate"),
  method: "GET"
};
console.log(updateOptions.path);
let updateReq = http.request(updateOptions, result => {
  console.log(`Update statusCode: ${result.statusCode}`);
  result.on("data", data => {
    console.log(data);
  });
});

updateReq.on ('error', error=> {
  console.error (error);
})*/
