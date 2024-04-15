function dataProcessor(serverProcessorURL, params) {
	this.serverProcessor = serverProcessorURL;
	this.postParams = params;
	this.obj = null;
	this.mandatoryFields = new Array(0);
	this.updatedRows = new Array(0);
	this.autoUpdate = true;
	this.updateMode = "cell";
	this._waitMode = 0;
	this._tMode = "GET";
	this._in_progress = {};
	this.enableUTFencoding(true);
	return this;
}
dataProcessor.prototype.setTransactionMode = function (mode, total) {
	this._tMode = mode;
	this._tSend = total;
};
dataProcessor.prototype.escape = function (data) {
	if (this._utf) {
		return encodeURIComponent(data);
	} else {
		return escape(data);
	}
};
dataProcessor.prototype.enableUTFencoding = function (mode) {
	this._utf = convertStringToBoolean(mode);
};
dataProcessor.prototype.setDataColumns = function (val) {
	if (typeof val == "string") {
		val = val.split(",");
	}
	this._columns = val;
};
dataProcessor.prototype.setOnAfterUpdate = function (ev) {
	if (typeof (ev) != "function") {
		ev = eval(ev);
	}
	this._afterUEvent = ev;
};
dataProcessor.prototype.getSyncState = function () {
	for (var i = 0; i < this.updatedRows.length; i++) {
		if (this.updatedRows[i]) {
			return false;
		}
	}
	return true;
};
dataProcessor.prototype.enableDebug = function (mode) {
	this._debug = convertStringToBoolean(mode);
};
dataProcessor.prototype.enableDataNames = function (mode) {
	this._endnm = convertStringToBoolean(mode);
};
dataProcessor.prototype.setUpdateMode = function (mode, dnd) {
	if (mode == "cell") {
		this.autoUpdate = true;
	} else {
		this.autoUpdate = false;
	}
	this.updateMode = mode;
	this.dnd = dnd;
};
dataProcessor.prototype.findRow = function (pattern) {
	for (var i = 0; i < this.updatedRows.length; i++) {
		if (pattern == this.updatedRows[i]) {
			return i;
		}
	}
	return -1;
};
dataProcessor.prototype.setUpdated = function (rowId, state, forceUpdate) {
	var rowInArray = this.findRow(rowId);
	if (rowInArray == -1) {
		rowInArray = this.updatedRows.length;
	}
	if (state) {
		this.updatedRows[rowInArray] = rowId;
		this.setRowTextBold(rowId);
		this.checkBeforeUpdate(rowId, this.autoUpdate || forceUpdate);
	} else {
		this.updatedRows[rowInArray] = this.undefined;
		this.setRowTextNormal(rowId);
	}
};
dataProcessor.prototype.setUpdatedTM = function (rowId, state) {
	this._lccm = true;
	if (this._waitMode) {
		this.autoUpdate = false;
		this.setUpdated(rowId, true);
		this.autoUpdate = true;
	} else {
		this.setUpdated(rowId, true);
	}
};
dataProcessor.prototype.setRowTextBold = function (rowId) {
	if (this.obj.mytype == "tree") {
		this.obj.setItemStyle(rowId, "font-weight:bold;");
	} else {
		this.obj.setRowTextBold(rowId);
	}
};
dataProcessor.prototype.setRowTextNormal = function (rowId) {
	if (this.obj.mytype == "tree") {
		this.obj.setItemStyle(rowId, "font-weight:normal;");
	} else {
		this.obj.setRowTextNormal(rowId);
		var row = this.obj.rowsAr[rowId];
		if (row) {
			for (var j = 0; j < row.childNodes.length; j++) {
				row.childNodes[j].wasChanged = false;
			}
		}
	}
};
dataProcessor.prototype.checkBeforeUpdate = function (rowId, updateFl) {
	var fl = true;
	if (this._in_progress[rowId] && (new Date()).valueOf() - this._in_progress[rowId] < 10000) {
		return;
	}
	var mandExists = false;
	var mFields = (this.obj._c_order ? this.obj._swapColumns(this.mandatoryFields) : this.mandatoryFields);
	for (var i = 0; i < mFields.length; i++) {
		if (mFields[i]) {
			mandExists = true;
			var val = this.obj.cells(rowId, i).getValue();
			var colName = this.obj.getHeaderCol(i);
			if ((typeof (mFields[i]) == "function" && mFields[i](val, colName)) || (typeof (mFields[i]) != "function" && val.toString()._dhx_trim() != "")) {
				this.obj.cells(rowId, i).cell.style.border = "";
			} else {
				fl = false;
				this.obj.cells(rowId, i).cell.style.border = "1px solid red";
			}
		}
	}
	if ((fl || !mandExists) && updateFl) {
		this.sendData(rowId);
	}
};
dataProcessor.prototype.checkBeforeUpdatePost = function (rowId, updateFl) {
	var fl = true;
	if (this._in_progress[rowId] && (new Date()).valueOf() - this._in_progress[rowId] < 10000) {
		return;
	}
	var mandExists = false;
	var mFields = (this.obj._c_order ? this.obj._swapColumns(this.mandatoryFields) : this.mandatoryFields);
	for (var i = 0; i < mFields.length; i++) {
		if (mFields[i]) {
			mandExists = true;
			var val = this.obj.cells(rowId, i).getValue();
			var colName = this.obj.getHeaderCol(i);
			if ((typeof (mFields[i]) == "function" && mFields[i](val, colName)) || (typeof (mFields[i]) != "function" && val.toString()._dhx_trim() != "")) {
				this.obj.cells(rowId, i).cell.style.border = "";
			} else {
				fl = false;
				this.obj.cells(rowId, i).cell.style.border = "1px solid red";
			}
		}
	}
	if ((fl || !mandExists) && updateFl) {
		this.sendDataPost(rowId);
	}
};
dataProcessor.prototype.sendData = function (rowId) {
	if (typeof rowId != "undefined") {
		if ((this.onBUpd) && (!this.onBUpd(rowId, this.obj.getUserData(rowId, "!nativeeditor_status") || "updated"))) {
			return false;
		}
		if (!this._tSend) {
			var a1 = this._getRowData(rowId);
			this._in_progress[rowId] = (new Date()).valueOf();
		} else {
			var a1 = this._getAllData();
		}
		var a2 = new dtmlXMLLoaderObject(this.afterUpdate, this, true);
		var a3 = this.serverProcessor + ((this.serverProcessor.indexOf("?") != -1) ? "&" : "?");
		if (this._debug) {
			alert("Send data to server \n URL:" + a3 + "\n Data:" + a1);
		}
		if (this._tMode != "POST") {
			a2.loadXML(a3 + a1);
		} else {
			a2.loadXML(a3, true, a1);
		}
		this._waitMode++;
		return [a3, a1];
	} else {
		if (this._waitMode && this.obj.mytype == "tree") {
			return;
		}
		for (var i = 0; i < this.updatedRows.length; i++) {
			if (typeof this.updatedRows[i] != "undefined") {
				this.checkBeforeUpdate(this.updatedRows[i], true);
				if (this._tSend) {
					break;
				}
				if (!this.autoUpdate) {
					break;
				}
			}
		}
	}
};
dataProcessor.prototype.sendDataPost = function (rowId) {
	if (typeof rowId != "undefined") {
		if ((this.onBUpd) && (!this.onBUpd(rowId, this.obj.getUserData(rowId, "!nativeeditor_status") || "updated"))) {
			return false;
		}
		if (!this._tSend) {
			var a1 = this._getRowData(rowId);
			this._in_progress[rowId] = (new Date()).valueOf();
		} else {
			var a1 = this._getAllData();
		}
		if(typeof this.postParams != "undefined" && this.postParams != "" && typeof a1 != "undefined" && a1 != "") {
            if(this.postParams.substr(-1) === "&") {
			    a1 = this.postParams + a1;
            } else {
			    a1 = this.postParams + "&" + a1;
            }
		}
		
		var a2 = new dtmlXMLLoaderObject(this.afterUpdate, this, true);
		var a3 = this.serverProcessor + ((this.serverProcessor.indexOf("?") != -1) ? "&" : "?");
		if (this._debug) {
			alert("Send data to server \n URL:" + a3 + "\n Data:" + a1);
		}
		if (this._tMode != "POST") {
			a2.loadXML(a3 + a1);
		} else {
			a2.loadXML(a3, true, a1);
		}
		this._waitMode++;
		return [a3, a1];
	} else {
		if (this._waitMode && this.obj.mytype == "tree") {
			return;
		}
		for (var i = 0; i < this.updatedRows.length; i++) {
			if (typeof this.updatedRows[i] != "undefined") {
				this.checkBeforeUpdatePost(this.updatedRows[i], true);
				if (this._tSend) {
					break;
				}
				if (!this.autoUpdate) {
					break;
				}
			}
		}
	}
};
dataProcessor.prototype._getAllData = function (rowId) {
	var out = new Array();
	var rs = new Array();
	for (var i = 0; i < this.updatedRows.length; i++) {
		if (this.updatedRows[i]) {
			out[out.length] = this._getRowData(this.updatedRows[i], this.updatedRows[i] + "_");
			rs[rs.length] = this.updatedRows[i];
		}
	}
	out[out.length] = "ids=" + rs.join(",");
	return out.join("&");
};
dataProcessor.prototype.defineAction = function (name, handler) {
	if (!this._uActions) {
		this._uActions = new Array();
	}
	this._uActions[name] = handler;
};
dataProcessor.prototype.setOnBeforeUpdateHandler = function (func) {
	if (typeof (func) == "function") {
		this.onBUpd = func;
	} else {
		this.onBUpd = eval(func);
	}
};
dataProcessor.prototype.afterUpdateCallback = function (sid, tid, action) {
	this.setUpdated(sid, false);
	var soid = sid;
	switch (action) {
	  case "insert":
		if (tid != sid) {
			if (this.obj.mytype == "tree") {
				this.obj.changeItemId(sid, tid);
			} else {
				this.obj.changeRowId(sid, tid);
			}
			sid = tid;
		}
		break;
	  case "delete":
		if (this.obj.mytype == "tree") {
			this.obj.deleteItem(sid);
			if (this._afterUEvent) {
				this._afterUEvent(sid, action, tid);
			}
			return;
		} else {
			this.obj.setUserData(sid, "!nativeeditor_status", "true_deleted");
			this.obj.deleteRow(sid);
		}
		break;
	}
	var z = this.obj.getUserData(sid, "!nativeeditor_status", "");
	if (z != "deleted") {
		this.obj.setUserData(sid, "!nativeeditor_status", "");
	}
	if (this._lccm) {
		for (var i = 0; i < this.updatedRows.length; i++) {
			if (this.updatedRows[i]) {
				this.obj.setUserData(this.updatedRows[i], "!nativeeditor_status", "inserted");
				this.setUpdated(this.updatedRows[i], true);
				break;
			}
		}
	}
	if (this._afterUEvent) {
		this._afterUEvent(soid, action, tid);
	}
};
dataProcessor.prototype.afterUpdate = function (that, b, c, d, xml) {
	if (that._debug) {
		alert("XML status: " + (xml.xmlDoc.responseXML ? "correct" : "incorrect") + "\nServer response: \n" + xml.xmlDoc.responseText);
	}
	var atag = xml.doXPath("//data/action");
	that._waitMode--;
	if ((!atag) || (!atag.length)) {
		var i = 0;
		var atag = xml.getXMLTopNode("data");
		while ((atag.childNodes[i]) && (atag.childNodes[i].tagName) && (atag.childNodes[i].tagName != "action")) {
			i++;
		}
		atag = atag.childNodes[i];
		var action = atag.getAttribute("type");
		var sid = atag.getAttribute("sid");
		var tid = atag.getAttribute("tid");
		if ((that._uActions) && (that._uActions[action]) && (!that._uActions[action](atag))) {
		} else {
			that.afterUpdateCallback(sid, tid, action);
		}
		that._in_progress[sid] = null;
	} else {
		for (var i = 0; i < atag.length; i++) {
			var btag = atag[i];
			var action = btag.getAttribute("type");
			var sid = btag.getAttribute("sid");
			var tid = btag.getAttribute("tid");
			if ((that._uActions) && (that._uActions[action]) && (!that._uActions[action](btag))) {
			} else {
				that.afterUpdateCallback(sid, tid, action);
			}
			that._in_progress[sid] = null;
		}
	}
	if (!that.stopOnError) {
		that.sendData();
	}
	that.stopOnError = false;
};
dataProcessor.prototype._getRowData = function (rowId, pref) {
	if (this.obj.mytype == "tree") {
		var z = this.obj._globalIdStorageFind(rowId);
		var z2 = z.parentObject;
		var i = 0;
		for (i = 0; i < z2.childsCount; i++) {
			if (z2.childNodes[i] == z) {
				break;
			}
		}
		var str = "tr_id=" + this.escape(z.id);
		str += "&tr_pid=" + this.escape(z2.id);
		str += "&tr_order=" + i;
		str += "&tr_text=" + this.escape(z.span.innerHTML);
		z2 = (z._userdatalist || "").split(",");
		for (i = 0; i < z2.length; i++) {
			str += "&" + this.escape(z2[i]) + "=" + this.escape(z.userData["t_" + z2[i]]);
		}
	} else {
		pref = (pref || "");
		var str = pref + "gr_id=" + this.escape(rowId);
		if (this.obj.isTreeGrid()) {
			str += "&" + pref + "gr_pid=" + this.escape(this.obj.getParentId(rowId));
		}
		var r = this.obj.getRowById(rowId);
		for (var i = 0; i < this.obj._cCount; i++) {
			if (this.obj._c_order) {
				var i_c = this.obj._c_order[i];
			} else {
				var i_c = i;
			}
			var c = this.obj.cells(r.idd, i);
			if (this._changed && !c.wasChanged()) {
				continue;
			}
			if (this._endnm) {
				str += "&" + pref + this.obj.getColumnId(i) + "=" + this.escape(c.getValue());
			} else {
				str += "&" + pref + "c" + i_c + "=" + this.escape(c.getValue());
			}
		}
		var data = this.obj.UserData[rowId];
		if (data) {
			for (var j = 0; j < data.keys.length; j++) {
				str += "&" + pref + data.keys[j] + "=" + this.escape(data.values[j]);
			}
		}
	}
	return str;
};
dataProcessor.prototype.setVerificator = function (ind, verifFunction) {
	if (verifFunction) {
		this.mandatoryFields[ind] = verifFunction;
	} else {
		this.mandatoryFields[ind] = true;
	}
};
dataProcessor.prototype.clearVerificator = function (ind) {
	this.mandatoryFields[ind] = false;
};
dataProcessor.prototype.init = function (anObj) {
	this.obj = anObj;
	this.obj.lWin = (new Date()).valueOf() + "-" + Math.random(1000) + "-" + (anObj.entBox || anObj.parentObject).id;
	var self = this;
	if (this.obj.mytype == "tree") {
		if (this.obj.setOnEditHandler) {
			this.obj.setOnEditHandler(function (state, id) {
				if (state == 3) {
					self.setUpdated(id, true);
				}
				return true;
			});
		}
		this.obj.setDropHandler(function (id, id_2, id_3, tree_1, tree_2) {
			if (tree_1 == tree_2) {
				self.setUpdated(id, true);
			}
		});
		this.obj._onrdlh = function (rowId) {
			var z = self.obj.getUserData(rowId, "!nativeeditor_status");
			if (z == "deleted") {
				return true;
			}
			self.obj.setUserData(rowId, "!nativeeditor_status", "deleted");
			self.setUpdated(rowId, true);
			self.obj.setItemStyle(rowId, "text-decoration : line-through;");
			return false;
		};
		this.obj._onradh = function (rowId) {
			self.obj.setUserData(rowId, "!nativeeditor_status", "inserted");
			self.setUpdatedTM(rowId, true);
		};
	} else {
		this.obj.attachEvent("onEditCell", function (state, id, index) {
			if (self._columns && !self._columns[index]) {
				return true;
			}
			var cell = self.obj.cells(id, index);
			if (state == 1) {
				if (cell.isCheckbox()) {
					self.setUpdated(id, true);
				}
			} else {
				if (state == 2) {
					if (cell.wasChanged()) {
						self.setUpdated(id, true);
					}
				}
			}
			return true;
		});
		this.obj.attachEvent("onRowPaste", function (id) {
			self.setUpdated(id, true);
		});
		this.obj.attachEvent("onRowIdChange", function (id, newid) {
			var ind = self.findRow(id);
			if (ind != -1) {
				self.updatedRows[ind] = newid;
			}
		});
		this.obj.attachEvent("onSelectStateChanged", function (rowId) {
			if (self.updateMode == "row") {
				self.sendData();
			}
			return true;
		});
		this.obj.attachEvent("onEnter", function (rowId, celInd) {
			if (self.updateMode == "row") {
				self.sendData();
			}
			return true;
		});
		this.obj.attachEvent("onBeforeRowDeleted", function (rowId) {
			if (this.dragContext && self.dnd) {
				window.setTimeout(function () {
					self.setUpdated(rowId, true);
				}, 1);
				return true;
			}
			var z = self.obj.getUserData(rowId, "!nativeeditor_status");
			if (z == "inserted") {
				self.setUpdated(rowId, false);
				return true;
			}
			if (z == "deleted") {
				return false;
			}
			if (z == "true_deleted") {
				return true;
			}
			self.obj.setUserData(rowId, "!nativeeditor_status", "deleted");
			self.obj.setRowTextStyle(rowId, "text-decoration : line-through;");
			self.setUpdated(rowId, true);
			return false;
		});
		this.obj.attachEvent("onRowAdded", function (rowId) {
			if (this.dragContext & self.dnd) {
				return true;
			}
			self.obj.setUserData(rowId, "!nativeeditor_status", "inserted");
			if (this.isTreeGrid() && this.autoUpdate) {
				self.setUpdatedTM(rowId, true);
			} else {
				self.setUpdated(rowId, true);
			}
			return true;
		});
	}
};