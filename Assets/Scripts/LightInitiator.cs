using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LightInitiator : MonoBehaviour
{
    [SerializeField]
    private Light[] lights;
    
    private Ray ray;
    private RaycastHit hit;

    private TargetStoneComponent[] components;
    private Dictionary<TargetStoneComponent, bool> calledComponents = new Dictionary<TargetStoneComponent, bool>();
    private LayerMask targetLayer;

    private float targetRot;
    private float rotSpeed = 180f;
    [SerializeField]
    private int[] angles = new int[] {90,90,90,90};
    [SerializeField]
    private int angleIndex = 0;

    // Start is called before the first frame update
    void Start()
    {
        targetRot = 0;
        targetLayer = LayerMask.GetMask("LightTargeting");
        ray = new Ray();
        components = (TargetStoneComponent[])GameObject.FindObjectsOfType(typeof(TargetStoneComponent));
        foreach(TargetStoneComponent component in components)
        {
            if(component.enabled)
                calledComponents.Add(component, false);
        }


    }

    // Update is called once per frame
    void Update()
    {
        if (this.targetRot != 0)
        {
            if (this.targetRot > 0)
            {
                this.transform.parent.Rotate(0,0,rotSpeed*Time.deltaTime);
                
                this.targetRot -= rotSpeed*Time.deltaTime;
                
            }
            else
            {
                this.transform.parent.Rotate(0, 0, rotSpeed*-Time.deltaTime);
                this.targetRot += rotSpeed*Time.deltaTime;
            }
            
        }
        if (Mathf.Abs(this.targetRot)<2*this.rotSpeed*Time.deltaTime)
        {
            this.transform.parent.Rotate(0, 0, this.targetRot);
            this.targetRot = 0;
        }
    }

    public void Rotate90()
    {
        this.targetRot += this.angles[angleIndex];
        this.angleIndex = (this.angleIndex + 1) % this.angles.Length;
    }

    public void RotateN90()
    {

        this.angleIndex = (this.angleIndex - 1) % this.angles.Length;
        if (this.angleIndex == -1)
        {
            this.angleIndex = this.angles.Length - 1;
        }
        this.targetRot -= this.angles[angleIndex];
        
    }
    private void FixedUpdate()
    {
        foreach(TargetStoneComponent component in components)
        {
            calledComponents[component] = false;
        }

        for(int i =0; i < lights.Length; i++)
        {
            ray.origin = lights[i].transform.position;
            ray.direction = lights[i].transform.forward;
            if(Physics.Raycast(ray,out hit,this.targetLayer))
            {
                TargetStoneComponent component;
                if((component=hit.transform.gameObject.GetComponent<TargetStoneComponent>())!=null||
                    (component= hit.transform.gameObject.GetComponentInChildren<TargetStoneComponent>())!=null)
                {
                    component.Call();
                    if (!component.IsCalled)
                    {
                        component.Call();
                        
                        
                    }
                    
                    calledComponents[component] = true;

                }

            }
           

        }
        foreach(TargetStoneComponent component in this.calledComponents.Keys)
        {
            
            if (!this.calledComponents[component]&&component.IsCalled)
            {
                print("Component:" + component.gameObject.name);
                component.UnCall();
            }
         
        }

        
        //Vector3 targetVector = new Vector3(this.transform.parent.transform.localEulerAngles.x,this.transform.parent.transform.localEulerAngles.y,targetRot);
        //this.transform.parent.transform.localEulerAngles = Vector3.Lerp(this.transform.parent.transform.localEulerAngles,targetVector,Time.deltaTime);
    }
}
