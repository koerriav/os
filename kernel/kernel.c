void main(){
	char* video_memory = (char*) 0xb8000;
	char* str = "Hello World!\n";
	int i=0;
	for(;i<12;i++){
		video_memory[i*2] = str[i];
		video_memory[i*2+1] = i;
	}
}
