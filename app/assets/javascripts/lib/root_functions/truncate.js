String.prototype.trunc =
     function(n,useWordBoundary){
         var toLong = this.length>n,
             s_ = toLong ? this.substr(0,n-1) : this;
         s_ = useWordBoundary && toLong ? s_.substr(0,s_.lastIndexOf(' ')) : s_;
         return  toLong ? s_ + '...' : s_;
      };

String.prototype.rtrunc =
     function(n,useWordBoundary){
         var rev = this.split("").reverse().join("");
         var toLong = rev.length>n,
             s_ = toLong ? rev.substr(0,n-1) : rev;
         s_ = useWordBoundary && toLong ? s_.substr(0,s_.lastIndexOf(' ')) : s_;
         var output = toLong ? s_ + '...' : s_;
         return output.split("").reverse().join("");
      };      