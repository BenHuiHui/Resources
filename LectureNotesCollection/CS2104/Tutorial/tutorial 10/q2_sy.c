#include <stdio.h>
#include <stdlib.h>

struct Drawable{
    int scaleFactor;    // TODO: how to represent "protected" scope in Java?
    void (*draw)(struct Drawable *self);
    void (*scaleDraw)(struct Drawable *self,int factor);
};

void Drawable_draw(struct Drawable *self){
    printf("Generic drawable object");
}

void Drawable_scaleDraw(struct Drawable *self, int factor){
    self->scaleFactor = factor;
    (*(self->draw))(self);
    self->scaleFactor = 1;
}

void init_Drawable(struct Drawable *self){
    self->draw = Drawable_draw;
    self->scaleDraw = Drawable_scaleDraw;
}

struct Circle{
    // first implement the old code
    int scaleFactor;
    void (*draw)(struct Drawable *self);
    void (*scaleDraw)(struct Drawable *self,int factor);

    int x,y,radius;
    void (*super_draw)(struct Drawable *self);
    void (*super_scaleDraw)(struct Drawable *self,int factor);
};

void Circle_draw(struct Circle *self){
    printf("Circle with center at(%d,%d) and radiums %d",self->x,self->y,self->radius*self->scaleFactor);
}

void init_Circle(struct Circle *self){
    init_Drawable((struct Drawable*)self);
    self->super_draw = self->draw; self->super_scaleDraw = self->scaleDraw;

    self->draw = Circle_draw;
}

struct Circle* make_Circle_1(int x, int y, int radius){
    struct Circle* res = (struct Circle*)malloc(sizeof(struct Circle));
    init_Circle(res);
    res->x = x; res->y = y; res->radius = radius;
}

struct Square{
    // first implement the old code
    int scaleFactor;
    void (*draw)(struct Drawable *self);
    void (*scaleDraw)(struct Drawable *self,int factor);

    int x,y,side;
    void (*super_draw)(struct Drawable *self);
    void (*super_scaleDraw)(struct Drawable *self,int factor);
};

void Square_draw(struct Square* self){
    printf("Squuare with corner at (%d,%d) and side %d",self->x,self->y,self->scaleFactor * self->scaleFactor);
}

void init_Square(struct Square *self){
    init_Drawable((struct Drawable*)self);
    self->super_draw = self->draw; self->super_scaleDraw = self->scaleDraw;

    self->draw = Square_draw;
}

struct Square* make_Square_1(int x, int y, int side){
    struct Square* res = malloc(sizeof(struct Square));
    init_Square(res);
    res->x = x; res->y = y; res->side = side;
}

int main(int argc,char *argv[]){
    struct Drawable *x;
    if(argc >= 2 && (strcmp(argv[1],"c") == 0)){
        x = make_Circle_1(10,10,10);
    } else{
        x = make_Square_1(5,5,5);
    }

    (*(x->scaleDraw))(x,10);

    return 0;
}
