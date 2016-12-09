vec2 curr = cPos;
for(int i = 0; i < 10; i++){
    curr = complexPow(curr,vec2(2.0,0.0)) + vec2(time,0.2);
}
res = curr;