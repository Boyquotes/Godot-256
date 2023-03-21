shader_type canvas_item;

void vertex(){
	VERTEX.x += cos(TIME*10.0) * 2.0;
	VERTEX.y += sin(TIME*10.0) *2.0;
	
}