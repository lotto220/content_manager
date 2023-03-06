import { content_manager_backend } from "../../declarations/content_manager_backend";

document.getElementById("download").onclick = async (ev) => {
  console.log("download clicked");
  let view = new Uint8Array();
  let totalBytes = await content_manager_backend.getTotalBytes();
  let numBlocks = await content_manager_backend.getNumBlocks();
  for(let i = 0; i < numBlocks; i++) {
    let received = await content_manager_backend.download(i);
    let tempView = view;
    view = new Uint8Array(view.length+ received.length);
    view.set(tempView);
    view.set(received, tempView.length);
    console.log("received " + view.length);
  }

  var a = window.document.createElement('a');
  a.href = window.URL.createObjectURL(new Blob([view], { type: 'application/octet-stream' }));
  a.download = "received.ppm";
  document.body.appendChild(a)
  a.click();
  document.body.removeChild(a)
};

document.querySelector("form").addEventListener("submit", async (e) => {
  e.preventDefault();
  console.log("uploading file");

  let fileInput = document.getElementById("photo");
  fileInput.onchange = e => {
    var file = e.target.files[0]; 

    // get a reader from the selected file and read bytes
    var reader = new FileReader();
    reader.readAsArrayBuffer(file);

    reader.onload = readerEvent => {
        var content = readerEvent.target.result; // this is the content!

        // interpret read buffer as a byte array
        let view = new Uint8Array(content);
        let blockSize = 2000000; // 1 MB
        let numBlocks = Math.ceil(view.length / blockSize);
        let totalBytes = view.length;
        content_manager_backend.prime(numBlocks, blockSize, totalBytes).then(async () => {
          for(let i = 0; i < numBlocks; i++) {
            let start = i * blockSize;
            let end = (i + 1) * blockSize;
            if(end > view.length) {
              end = view.length;
            }
            await content_manager_backend.upload(i, view.slice(start, end)).then(resp => {
              console.log(resp);
            });
          }
        });

        console.log("Initial content:")
        console.log(content);
        console.log("\n")
    }
  }
  fileInput.click();
});

