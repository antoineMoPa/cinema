vec2 curr = vec2(0.0,0.0);
for(int i = 0; i < 10; i++){
    curr = complexPow(curr,vec2(2.0,0.0)) + cPos;
}
res = curr;