local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	aux.GlobalCheck(s,function()
		s[0]=false
		s[1]=Group.CreateGroup()
		s[1]:KeepAlive()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_LEAVE_FIELD)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
			aux.AddValuesReset(function()
			s[0]=false
			s[1]:Clear()
		end)
	end)
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	for ec in aux.Next(eg) do
		if REASON_EFFECT&ec:GetReason()>0
			and ec:IsPreviousPosition(POS_FACEUP) and not s[0] and (ec:IsReason(REASON_EFFECT)) then
			if s[1]:IsContains(ec) then s[0]=true
			else s[1]:AddCard(ec) end
		end
	end
end
function s.filter(c,g)
	return g:IsExists(Card.IsCode,2,c,c:GetCode())
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return s[0] or s[1]:IsExists(s.filter,2,nil,s[1]) and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,true)
end
function s.lv_fil(c,i)
	return c:GetLevel()==i and not c:IsType(TYPE_XYZ)
end
function s.filter2(c,tg,g,lv)
	local tg=g:IsExists(Card.IsCode,2,c,c:GetCode()) 
	local c=tg:GetFirst()
	while c do
		c=g:GetNext()
		local lv2=c:GetLevel()
		if lv==lv2 and tg and tg:FilterCount(s.lv_fil,nil,c:GetLevel())>=3 then return true end
		end
	return false
end
function s.spfilter(c,e,tp,lv)
	local lv=c:GetLevel()
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and s[1]:IsExists(s.filter2,2,nil,s[1],c,lv,c:GetLevel())
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lv=c:GetLevel()
	if chkc then return chkc:IsLocation(LOCATION_DECK) and s.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local lv=c:GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,true,lv) 
	if #sg>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end