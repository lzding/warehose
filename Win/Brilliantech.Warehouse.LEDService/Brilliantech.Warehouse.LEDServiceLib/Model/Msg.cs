﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Brilliantech.Warehouse.LEDServiceLib.Model
{ 

    public class Msg<T>
    {
        private bool result;
        public Msg()
        {
            this.Result = false;
        }

        public bool Result
        {
            get { return result; }
            set
            {
                if (value)
                {
                    this.Code = 1;
                }
                result = value;
            }
        }
     
        public int Code{get;set;}
        public string Content { get; set; }
        public T Object { get; set; }
    }
}
