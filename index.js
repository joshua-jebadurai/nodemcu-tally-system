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

getKeys (options);

function getKeys(options) {
  const req = http.request(options, res => {
  console.log(`statusCode: ${res.statusCode}`);

    res.on("data", d => {
      //process.stdout.write(d);
      const $ = cheerio.load(d);
      $(".tallyLink").each(function(index, element) {
        console.log(element.attribs["href"]);
        //console.log(element.children[0].data);
        options.path = element.attribs["href"].replace ('tally', 'tallyupdate');
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
