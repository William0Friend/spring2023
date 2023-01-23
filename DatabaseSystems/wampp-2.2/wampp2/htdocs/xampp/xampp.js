var light=1;
var lightm="welcome";
var ms=document.all!=null;

function o(x,m)
{
        if(light==x)return;
        document.images[light+1].src="img/"+lightm+"_b.gif";
        light=x;
        lightm=m;
}

function l(n,m)
{
        document.images[n+1].src="img/"+m+"_w.gif";
}

function d(n,m)
{
        if(light==n)return;
        document.images[n+1].src="img/"+m+"_b.gif";
}

function c(u)
{
        parent.content.location=u;
}