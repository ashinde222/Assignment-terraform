
resource "local_file" "velocity" {


	filename = "/mnt/velocity.html"
	content = "hello velocity"


}

resource "local_file"  "test" {

    filename = "/mnt/test.html"
    content = "hello test"
 
}



