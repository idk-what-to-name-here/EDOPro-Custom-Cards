--ＣＸ 熱血指導神アルティメットレーナー (Anime)
--CXyz Coach Lord Ultimatrainer (Anime)
local s,id=GetID()
function s.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(s.uncon)
	e1:SetOperation(s.unop)
	c:RegisterEffect(e1)
end
s.listed_names={30741334}
function s.uncon(e,tp,eg,ep,ev,re,r,rp)
	local ha=Duel.GetOverlayGroup(tp,LOCATION_MZONE,0)
	if not re:IsActiveType(TYPE_MONSTER) then return false end
	local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_BECOME_TARGET,true)
	if res then
		if trp==tp and tre:IsActiveType(TYPE_MONSTER) and teg:IsContains(ha) then
			return true
		end
	end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	if ex and tg~=nil and tg:IsContains(ha) then
		return true
	end
	ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_TOHAND)
	if ex and tg~=nil and tg:IsContains(ha) then
		return true
	end
	ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_REMOVE)
	if ex and tg~=nil and tg:IsContains(ha) then
		return true
	end
	ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_TODECK)
	if ex and tg~=nil and tg:IsContains(ha) then
		return true
	end
	ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_RELEASE)
	if ex and tg~=nil and tg:IsContains(ha) then
		return true
	end
	ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_TOGRAVE)
	if ex and tg~=nil and tg:IsContains(ha) then
		return true
	end
	ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_CONTROL)
	if ex and tg~=nil and tg:IsContains(ha) then
		return true
	end
	ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DISABLE)
	if ex and tg~=nil and tg:IsContains(ha) then
		return true
	end
	return false
end
function s.unop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetReset(RESET_CHAIN)
		e2:SetValue(s.efilter)
		c:RegisterEffect(e2)
	end
end
function s.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER)
end