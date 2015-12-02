/*
*
* Chechsum - Vala
* Author: Chiheb NeXus - 2015
* Blog: www.nexus-coding.blogspot.com
*
* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; either version 3 of the License.
*
* This program is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*  
*  You should have received a copy of the GNU General Public License
*  along with this program; if not, write to the Free Software
*  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
*  MA 02110-1301, USA. 
*
*
*/

using Gtk;

class GenHash : Gtk.Window{

	private string _filePath {get; set; default= " Enter your path and clic enter or choose a file";}
	// getter & setter of _filePath 
	public string filePath{
		get{ return _filePath;}
		set{ _filePath = value;}
	}
	// CalculStatus: Prevent double calcul process
	private bool _calcStatus {get; set; default= false;}
	// getter & setter of _calcStatus
	public bool calcStatus{
		get{ return _calcStatus;}
		set{ _calcStatus = value;}
	}

	private string _filePathCompare {get; set; default = "Choose your path";}
	public string filePathCompare{
		get{ return _filePathCompare;}
		set{ _filePathCompare = value;}
	}

	// Global entryHashFile
	private Gtk.Entry entryHashFile = new Gtk.Entry();
	// Global compareHashFile
	private Gtk.Entry compareHashFile = new Gtk.Entry();
	// Global variables md5ChechButton, sha1CheckButton, sha256CheckButton, sha512CheckButton
	private Gtk.CheckButton md5CheckButton = new Gtk.CheckButton.with_label("MD5");
	private Gtk.CheckButton sha1CheckButton = new Gtk.CheckButton.with_label("SHA1");
	private Gtk.CheckButton sha256CheckButton = new Gtk.CheckButton.with_label("SHA256");
	private Gtk.CheckButton sha512CheckButton = new Gtk.CheckButton.with_label("SHA512");
	// Global variables md5ChechButtonCompare, sha1CheckButtonCompare, sha256CheckButtonCompare, sha512CheckButtonCompare
	private Gtk.CheckButton md5CheckButtonCompare = new Gtk.CheckButton.with_label("MD5");
	private Gtk.CheckButton sha1CheckButtonCompare = new Gtk.CheckButton.with_label("SHA1");
	private Gtk.CheckButton sha256CheckButtonCompare = new Gtk.CheckButton.with_label("SHA256");
	private Gtk.CheckButton sha512CheckButtonCompare = new Gtk.CheckButton.with_label("SHA512");
	// Global TextView
	private Gtk.TextView textView = new Gtk.TextView();


	public GenHash(){
		// GenHash constructor
		this.set_title("Vala - Checksum v0.0.1");
		this.window_position = Gtk.WindowPosition.CENTER;
		this.set_default_size(500,800);
		this.set_border_width(10);
		this.set_resizable(false);
		this.icon_name = "applications-engineering";
		this.destroy.connect(() => {
				stdout.printf("Safe window destruction...\nDone.\n");
				Gtk.main_quit();
		});
		var grid = new Gtk.Grid();
		var mainBox = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
		mainBox.pack_start(grid, true, true, 0);
		this.add(mainBox);
		// Stack where label exists		
		var stack = new Gtk.Stack();
		stack.set_homogeneous(true);
		stack.set_transition_type(Gtk.StackTransitionType.SLIDE_LEFT_RIGHT);
		stack.set_transition_duration(1000);
		grid.attach(stack, 0, 2, 1, 1);
		// StackSwitcher: transition's effetcs
		var switcher = new Gtk.StackSwitcher();		
		switcher.set_stack(stack);
		grid.attach(switcher, 0, 0, 1, 1);
		var separator = new Gtk.Separator(Gtk.Orientation.VERTICAL);
		var hashFile = new Gtk.Label("Enter your path file");
		entryHashFile.set_text(getCurrentEntryPath());
		entryHashFile.activate.connect(() => {
			this.filePath = entryHashFile.get_text();
		});
		// Add delete text icon to entryHashFile
		entryHashFile.set_icon_from_icon_name(Gtk.EntryIconPosition.SECONDARY, "edit-clear");
		compareHashFile.set_icon_from_icon_name(Gtk.EntryIconPosition.SECONDARY, "edit-clear");
		// Connect icon: edit-clear to anonymous function to delete entry text
		entryHashFile.icon_press.connect((pos, event) => {
			if(pos == Gtk.EntryIconPosition.SECONDARY){
					entryHashFile.set_text("");
			}
		});
		compareHashFile.icon_press.connect((pos, event) => {
			if(pos == Gtk.EntryIconPosition.SECONDARY){
				compareHashFile.set_text("");
			}
			});
		// FIXME: Not a FileChooserButton
		var filechooserbutton = new FileChooserButton("Select File", Gtk.FileChooserAction.OPEN);
		filechooserbutton.file_set.connect(on_file_set);
		// Choose hash name Label				
		var typeCheckSum = new Gtk.Label("Choose hash name");
		// packing hashFile, entryHashFile, typeCheckSum into box
		var box = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
		box.pack_start(separator, true, true, 10);
		box.pack_start(hashFile, true, true, 0);
		box.pack_start(entryHashFile, true, true, 0);
		box.pack_start(filechooserbutton, true, true, 0);
		box.pack_start(typeCheckSum, true, true, 0);
		// Set wrap mode to: Gtk.WrapMode.Word
		textView.set_wrap_mode(Gtk.WrapMode.WORD_CHAR);
		textView.set_editable(false);		
		// Connect md5CheckButton to a signal
		md5CheckButton.toggled.connect(() => {
			if(md5CheckButton.active){
				this.set_non_sensitive_button("FILE");
				this.set_non_active_button("MD5", "FILE");
				textView.buffer.text = this.HashSum(this.filePath, "MD5", "FILE");
				this.set_sensitive_button("FILE");
				this.set_all_non_active_button("FILE");
			}
		});
		// Connect sha1Checkbutton to a signal
		sha1CheckButton.toggled.connect(() => {
			if(sha1CheckButton.active){
				this.set_non_sensitive_button("FILE");
				this.set_non_active_button("SHA1", "FILE");
				textView.buffer.text = this.HashSum(this.filePath, "SHA1", "FILE");
				this.set_sensitive_button("FILE");
				this.set_all_non_active_button("FILE");
			}
		});
		// Connect sha256CheckButton to a signal
		sha256CheckButton.toggled.connect(() => {
			if(sha256CheckButton.active){
				this.set_non_sensitive_button("FILE");
				this.set_non_active_button("SHA256", "FILE");
				textView.buffer.text = this.HashSum(this.filePath, "SHA256", "FILE");
				this.set_sensitive_button("FILE");
				this.set_all_non_active_button("FILE");
				
			}
		});
		// Connect sha512CheckButton to a signal
		sha512CheckButton.toggled.connect(() => {
			if(sha512CheckButton.active){
				this.set_non_sensitive_button("FILE");
				this.set_non_active_button("SHA512", "FILE");	
				textView.buffer.text = this.HashSum(this.filePath, "SHA512", "FILE");
				this.set_sensitive_button("FILE");
				this.set_all_non_active_button("FILE");
			}
		});
		// vbox is a Vertical Box wich contain: md5ChckButton, sha1CheckButton, sha256CheckButton, sha512CheckButton
		var vbox = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
		vbox.pack_start(md5CheckButton, true, true, 0);
		vbox.pack_start(sha1CheckButton, true, true, 0);
		vbox.pack_start(sha256CheckButton, true, true, 0);
		vbox.pack_start(sha512CheckButton, true, true, 0);
		// Add vbox (checkbutton) to box
		box.pack_end(vbox, true, true, 10);
		// Add textView to ScrolledWindow then to mainBox
		//var scrolled = new Gtk.ScrolledWindow(null, null);
		//scrolled.add(textView);
		mainBox.pack_end(textView, true, true, 0);
		// Add
		stack.add_titled(box, "page-1", "File Checksum");

		// CompareBox in page 2
		var compareBox = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
		var compareBoxHash = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);

		var compareHash = new Gtk.Label("Enter your hash");
		var separatorCompare = new Gtk.Separator(Gtk.Orientation.HORIZONTAL);
		compareBox.pack_start(separatorCompare, true, true, 0);
		compareBox.pack_start(compareHash, true, true, 10);
		compareBox.pack_start(compareHashFile, true, true, 0);

		md5CheckButtonCompare.toggled.connect(() =>{
			this.set_non_sensitive_button("COMPARE");
			this.set_non_active_button("MD5", "COMPARE");
			textView.buffer.text = this.HashSum(this.filePathCompare, "MD5", "COMPARE");
			this.set_sensitive_button("COMPARE");
			this.set_all_non_active_button("COMPARE");
			});
		sha1CheckButtonCompare.toggled.connect(() =>{
			this.set_non_sensitive_button("COMPARE");
			this.set_non_active_button("SHA1", "COMPARE");
			textView.buffer.text = this.HashSum(this.filePathCompare, "SHA1", "COMPARE");
			this.set_sensitive_button("COMPARE");
			this.set_all_non_active_button("COMPARE");
			});
		sha256CheckButtonCompare.toggled.connect(() =>{
			this.set_non_sensitive_button("COMPARE");
			this.set_non_active_button("SHA256", "COMPARE");
			textView.buffer.text = this.HashSum(this.filePathCompare, "SHA256", "COMPARE");
			this.set_sensitive_button("COMPARE");
			this.set_all_non_active_button("COMPARE");
			});
		sha512CheckButtonCompare.toggled.connect(() =>{
			this.set_non_sensitive_button("COMPARE");
			this.set_non_active_button("SHA512", "COMPARE");
			textView.buffer.text = this.HashSum(this.filePathCompare, "SHA512", "COMPARE");
			this.set_sensitive_button("COMPARE");
			this.set_all_non_active_button("COMPARE");
			});

		compareBoxHash.pack_start(md5CheckButtonCompare, true, true, 0);
		compareBoxHash.pack_start(sha1CheckButtonCompare, true, true, 0);
		compareBoxHash.pack_start(sha256CheckButtonCompare, true, true, 0);
		compareBoxHash.pack_start(sha512CheckButtonCompare, true, true, 0);

		var filechooserbuttonCompare = new FileChooserButton("Select File", Gtk.FileChooserAction.OPEN);
		filechooserbuttonCompare.file_set.connect(on_file_set_compare);
		// Choose your hash page2
		var chooseHashCompare = new Gtk.Label("Choose your hash");
		compareBox.pack_start(filechooserbuttonCompare, true, true, 0);
		compareBox.pack_start(chooseHashCompare, true, true, 0);
		compareBox.pack_start(compareBoxHash, true, true, 0);		
		stack.add_titled(compareBox, "page-2", "Compare checksum");

		var docBox = new Gtk.Box(Gtk.Orientation.VERTICAL, 0);
		var nexusBlog = new Gtk.LinkButton.with_label("http://www.nexus-coding.blogspot.com", "Blog: Chiheb NeXus");
		var md5Doc = new Gtk.LinkButton.with_label("https://en.wikipedia.org/wiki/MD5", "Wikipedia: MD5");
		var sha1Doc = new Gtk.LinkButton.with_label("https://en.wikipedia.org/wiki/SHA-1", "Wikipedia: SHA1");
		var sha256Doc = new Gtk.LinkButton.with_label("https://en.wikipedia.org/wiki/SHA-2", "Wikipedia: SHA256");
		var sha512Doc = new Gtk.LinkButton.with_label("https://en.wikipedia.org/wiki/SHA-2", "Wikipedia: SHA512");

		docBox.pack_start(nexusBlog, true, true, 0);
		docBox.pack_start(md5Doc, true, true, 0);
		docBox.pack_start(sha1Doc, true, true, 0);
		docBox.pack_start(sha256Doc, true, true, 0);
		docBox.pack_start(sha512Doc, true, true, 0);
		stack.add_titled(docBox, "page-3", "Documentation");
		}

		private void clear_textView(){
			this.textView.buffer.text = "Please wait ...\nIn progress ...";
		}

		private void set_all_non_active_button(string page){
			if(page == "FILE"){
				this.md5CheckButton.set_active(false);
				this.sha1CheckButton.set_active(false);
				this.sha256CheckButton.set_active(false);
				this.sha512CheckButton.set_active(false);
			}
			if(page == "COMPARE"){
				this.md5CheckButtonCompare.set_active(false);
				this.sha1CheckButtonCompare.set_active(false);
				this.sha256CheckButtonCompare.set_active(false);
				this.sha512CheckButtonCompare.set_active(false);
			}
		}

		private void set_non_active_button(string button, string page){
			// Set non active CheckButton
			if(page == "FILE"){
				switch(button){
					case "MD5":{
						this.sha1CheckButton.set_active(false);
						this.sha256CheckButton.set_active(false);
						this.sha512CheckButton.set_active(false);
						break;
					}
					case "SHA1":{
						this.md5CheckButton.set_active(false);
						this.sha256CheckButton.set_active(false);
						this.sha512CheckButton.set_active(false);
						break;
					}
					case "SHA256":{
						this.md5CheckButton.set_active(false);
						this.sha1CheckButton.set_active(false);
						this.sha512CheckButton.set_active(false);
						break;
					}
					case "SHA512":{
						this.md5CheckButton.set_active(false);
						this.sha1CheckButton.set_active(false);
						this.sha256CheckButton.set_active(false);
						break;
					}
					default:
					stdout.printf("ERROR!\n");
						break;
				}
			}
			if(page == "COMPARE"){
				switch(button){
					case "MD5":{
						this.sha1CheckButtonCompare.set_active(false);
						this.sha256CheckButtonCompare.set_active(false);
						this.sha512CheckButtonCompare.set_active(false);
						break;
					}
					case "SHA1":{
						this.md5CheckButtonCompare.set_active(false);
						this.sha256CheckButtonCompare.set_active(false);
						this.sha512CheckButtonCompare.set_active(false);
						break;
					}
					case "SHA256":{
						this.md5CheckButtonCompare.set_active(false);
						this.sha1CheckButtonCompare.set_active(false);
						this.sha512CheckButtonCompare.set_active(false);
						break;
					}
					case "SHA512":{
						this.md5CheckButtonCompare.set_active(false);
						this.sha1CheckButtonCompare.set_active(false);
						this.sha256CheckButtonCompare.set_active(false);
						break;
					}
					default:
					stdout.printf("ERROR!\n");
						break;

			}
		}
	}

		private void set_non_sensitive_button(string page){
			if(page == "FILE"){
				// Set all CheckButton non sensitive
				this.md5CheckButton.set_sensitive(false);
				this.sha1CheckButton.set_sensitive(false);
				this.sha256CheckButton.set_sensitive(false);
				this.sha512CheckButton.set_sensitive(false);
			}
			if(page == "COMPARE"){
				this.md5CheckButtonCompare.set_sensitive(false);
				this.sha1CheckButtonCompare.set_sensitive(false);
				this.sha256CheckButtonCompare.set_sensitive(false);
				this.sha512CheckButtonCompare.set_sensitive(false);
			}
		}

		private void set_sensitive_button(string page){
			if(page == "FILE"){
				// Set all CheckButton sensitive
				this.md5CheckButton.set_sensitive(true);
				this.sha1CheckButton.set_sensitive(true);
				this.sha256CheckButton.set_sensitive(true);
				this.sha512CheckButton.set_sensitive(true);
			}
			if(page == "COMPARE"){
				this.md5CheckButtonCompare.set_sensitive(true);
				this.sha1CheckButtonCompare.set_sensitive(true);
				this.sha256CheckButtonCompare.set_sensitive(true);
				this.sha512CheckButtonCompare.set_sensitive(true);
			}
		}

		private string HashSum(string path, string hash, string type){

			// Clear textView
			this.clear_textView();

			var file = File.new_for_path(path);
			if(!file.query_exists()){
					return @"Path didn't exist: $path";
			}else{
				switch (hash){
					case "MD5":
						Checksum checksum = new Checksum (ChecksumType.MD5);
						return this.calcHash(checksum, path, hash, type);

					case "SHA1":
						Checksum checksum = new Checksum (ChecksumType.SHA1);
						return this.calcHash(checksum, path, hash, type);

					case "SHA256":
						Checksum checksum = new Checksum (ChecksumType.SHA256);
						return this.calcHash(checksum, path, hash, type);

					case "SHA512":
						Checksum checksum = new Checksum (ChecksumType.SHA512);
						return this.calcHash(checksum, path, hash, type);

					default:
						return "Error!";
				}
			}
		}

		private string calcHash(Checksum checksum, string path, string hash, string type){
			unowned string digest = "Wait until process finish!";
			string status;
			if(this.calcStatus == false){
				// calcStatus = true => running!
				this.calcStatus = true;
				var file = File.new_for_path(path);
				if(!file.query_exists()){
					stderr.printf("File %s didn't exist!\n", file.get_path());
				}
				FileStream stream = FileStream.open (path, "rb");
				uint8 fbuf[100];
				size_t size;
				while ((size = stream.read (fbuf)) > 0){
					checksum.update (fbuf, size);
					// Prevent freezing GUI
					while(Gtk.events_pending()){
						Gtk.main_iteration();
					}
				}
				digest = checksum.get_string ();
				//stdout.printf ("%s: %s\n", hash, digest);
			}else{
				stdout.printf("Wait until the calcul finish!\n");
			}
			// calcStatus = false => off!
			this.calcStatus = false;

			switch(type){
				case "FILE":
					return @"Path: $path\nhash Type: $hash\nHash: $digest\n";
				case "COMPARE":
					if(compareHashFile.get_text() == digest){
						status = "Hashes are equal!";
						// Free digest
						digest = "";
					}else{
						status = "Hashes are not equal!";
						// Free digest
						digest = "";
					}
					return @"$status";
				default:
					return "ERROR OCCURED!";
			}

			}

		private void on_file_set(FileChooserButton filechooserbutton){
			var filename = filechooserbutton.get_filename();
			this.filePath = filename;
			entryHashFile.set_text(filechooserbutton.get_filename());
			}

		private string getCurrentEntryPath(){
			return this.filePath;
		}

		// Page2 signals and methods
		private void on_file_set_compare(FileChooserButton filechooserbutton){
			var filename = filechooserbutton.get_filename();
			this.filePathCompare = filename;
			}

		// main loop
		public static void main(string[] args){
		Gtk.init(ref args);
		var window = new GenHash();
		window.show_all();
		Gtk.main();
		}
}
